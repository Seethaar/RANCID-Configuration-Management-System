#! /bin/sh
######################################################
#Author: Ayyappan Ramanan                            #
#Date:04/07/2018                                     #
#Description: Script to grab current configuration of# 
#Palo Alto Firewalls using XML API                   #
######################################################

INVALID_PALOALTO_USER_FILE=/var/rancid/faas_palo_alto/invalidpalouser.db
rm $INVALID_PALOALTO_USER_FILE
for IP in `awk -F';' '{ print $1 }' /var/rancid/faas_palo_alto/router.db`
do
PALOFILE=/var/rancid/faas_palo_alto/configs/$IP.new
PA_API_TOKEN=`curl -k -X GET "https://$IP/api/?type=keygen&user=rancid&password=rancid" --connect-timeout 2 | awk -F'[><]' ' { print $7 } '`
if [ ! -z "$PA_API_TOKEN" ]
then
    if [ "$PA_API_TOKEN" != "Invalid credentials." ]
	then
            curl -k -X GET "https://$IP/api/?type=export&category=configuration&key=$PA_API_TOKEN" | xmllint --format - > $PALOFILE
        else
	    echo $IP >> $INVALID_PALOALTO_USER_FILE
    fi
else
    :
fi
done
exit 0
 
