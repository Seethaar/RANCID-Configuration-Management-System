#!/bin/bash
#########################################################
#Author: Ayyappan Ramanan                               #
#Date: 02/07/2018                                       #
#Description: Script to log on to individual huawei CPEs# 
#to grab version,serial number and current configuration#
#and store it in the huawei config repo with .new file  #
#extension                                              #
#########################################################

for IP in `awk -F';' '{ print $1 }' /var/rancid/managed_cpe_huawei/router.db`
do RESULTHUAWEI=`ping -c 1 -w 2 $IP | grep -o '1 received'` 
if [ ! -z "$RESULTHUAWEI" ]
then /usr/local/bin/hulogin -t 90 -c "screen-length 0 temporary;display version;display elabel;display curr" $IP > /var/rancid/managed_cpe_huawei/configs/$IP.new
else
:
fi
done
exit 0
