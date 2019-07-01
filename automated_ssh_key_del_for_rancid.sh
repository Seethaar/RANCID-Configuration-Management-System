#! /bin/bash
#######################################################
#Author: Ayyappan Ramanan                             #
#Date: 02/07/2018                                     #
#Description: Script to sieve through the logs to find#
#the CPEs to which the SSH attempts of rancid fail due#
#to changed pub key. Reasons could be changed CPE or  #
#SSH keygen re-run on that box                        #
#######################################################  

OUTPUTFILE=/var/rancid/SSHfailures.db
EMAILTEMPLATE=/usr/local/bin/SSHFailure_alert_template
cat /var/rancid/managed_cpe_huawei/configs/* | grep 'SSH known_hosts' | awk ' { print $6 } ' | sort | uniq > $OUTPUTFILE
find /var/log/rancid -type f -not -empty -not -path "/var/log/rancid/old/*" -name 'managed_cpe_cisco*' -exec grep 'SSH known_hosts' {} \; | awk ' { print $1 } ' | sort | uniq >> $OUTPUTFILE

#DELETION OF THOSE CPEs FROM /usr/local/rancid/.ssh/known_hosts FILE
if [ -s $OUTPUTFILE ]
then
    for node in `cat $OUTPUTFILE`; do sed -i "/$node/d" /usr/local/rancid/.ssh/known_hosts;done
    cat $EMAILTEMPLATE $OUTPUTFILE | mail -s "Alert: SSH keys for some Cisco & Huawei CPEs were deleted on rancid" ayyapanr@hotmail.com.au
else
    rm $OUTPUTFILE
fi
exit 0
