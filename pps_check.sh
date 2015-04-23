#!/bin/bash
#
# This script collects the in/out pps values via snmp from
# hosts , if the values are higher than the threshold
# variable, an alert is generated.
#
# Start
#

# declare variables

# shell used to run command string
shell=/bin/bash

# python
python=/usr/bin/python

# sms module
sms=/var/argus/sms.py

# pps  threshold
threshold=20000

# email addresses and mobile numbers for notifications
mail_dest='address@domain.com address2@domain2.co.za' 
# numbers 
mobile_dest='12345678,3456789'

# from field that will appear in the recieved message
email_from="From:sourceaddress@domain.com"

# snmpwalk configuration information
cmd=/usr/bin/snmpwalk
version='-v 2c'
comm='-c string'

# specific snmp oids
oid_pps_in='1.3.6.1.4.1.9.2.2.1.1.7'
oid_pps_out='1.3.6.1.4.1.9.2.2.1.1.9'

# host identifiers
host_1=name-of-router-1
host_2=name-of-router-2

# snmp interface index numbers
host_1_intf='.1'
host_2_intf='.2'

# build the data gathering command using variables
# host_1 pps inbound data gathering
pps_in_host_1="$cmd $version $comm $host_1 $oid_pps_in$host_1_intf"
pps_in_host_1_int=$(echo $pps_in_host_1 | $shell | cut -d" " -f4)
# host_1 pps outbound data gathering
pps_out_host_1="$cmd $version $comm $host_1 $oid_pps_out$host_1_intf"
pps_out_host_1_int=$(echo $pps_out_host_1 | $shell | cut -d" " -f4)

# host_2 pps inbound data gathering
pps_in_host_2="$cmd $version $comm $host_2 $oid_pps_in$host_2_intf"
pps_in_host_2_int=$(echo $pps_in_host_2 | $shell | cut -d" " -f4)
# host_2 pps outbound data gathering
pps_out_host_2="$cmd $version $comm $host_2 $oid_pps_out$host_2_intf"
pps_out_host_2_int=$(echo $pps_out_host_2 | $shell | cut -d" " -f4)

# build mesages to be sent via sms
# host_1 inbound ppsx
mobile_msg_in_1=$(echo "'"'- Threshold Alert -' $host_1 '- Inbound' $pps_in_host_1_int'/pps'"'")
# host_1 outbound pps
mobile_msg_out_1=$(echo "'"'- Threshold Alert -' $host_1 '- Outbound' $pps_out_host_1_int'/pps'"'")
# host_2 inbound pps
mobile_msg_in_2=$(echo "'"'- Threshold Alert -' $host_2 '- Inbound' $pps_in_host_2_int'/pps'"'")
# host_2 outbound pps
mobile_msg_out_2=$(echo "'"'- Threshold Alert -' $host_2 '- Outbound' $pps_out_host_2_int'/pps'"'")


# check pps inbound value on host_1, if value above threshold, generate an alert
if [[ $(echo $pps_in_host_1_int) -ge $threshold ]];
then
  # when threshold is matched or exceeded, notify via email
  echo "- Threshold Alert" | mail -s "- PPS Threshold Alert - $host_1 - Inbound $pps_in_host_1_int/pps" $mail_dest -a $email_from
  # when threshold is matched or exceeded, notify via sms
  echo $python $sms $mobile_msg_in_1 $mobile_dest | $shell >/dev/null 2>&1
fi

# check pps outbound value on host_1, if value above threshold, generate an alert
if [[ $(echo $pps_out_host_1_int) -ge $threshold ]];
then
  # when threshold is matched or exceeded, notify via email
  echo "- Threshold Alert" | mail -s "- PPS Threshold Alert - $host_1 - Outbound $pps_out_host_1_int/pps" $mail_dest -a $email_from
  # when threshold is matched or exceeded, notify via sms
  echo $python $sms $mobile_msg_out_1 $mobile_dest | $shell >/dev/null 2>&1
fi

# check pps inbound value on host_2, if value above threshold, generate an alert
if [[ $(echo $pps_in_host_2_int) -ge $threshold ]];
then
  # when threshold is matched or exceeded, notify via email
  echo "- Threshold Alert" | mail -s "- PPS Threshold Alert - $host_2 - Inbound $pps_in_host_2_int/pps" $mail_dest -a $email_from
  # when threshold is matched or exceeded, notify via sms
  echo $python $sms $mobile_msg_in_2 $mobile_dest | $shell >/dev/null 2>&1
fi

# check pps outbound value on host_2, if value above threshold, generate an alert
if [[ $(echo $pps_out_host_2_int) -ge $threshold ]];
then
  # when threshold is matched or exceeded, notify via email
  echo "- Threshold Alert" | mail -s "- PPS Threshold Alert - $host_2 - Outbound $pps_out_host_2_int/pps" $mail_dest -a $email_from
  # when threshold is matched or exceeded, notify via sms
  echo $python $sms $mobile_msg_out_2 $mobile_dest | $shell >/dev/null 2>&1
fi

# End
