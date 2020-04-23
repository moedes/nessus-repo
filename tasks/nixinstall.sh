#!/bin/bash

rpm -ivh "$PT_nixfilepath"
/opt/nessus_agent/sbin/nessuscli agent link --host=cloud.tenable.com --key="$PT_key" --port=443
/bin/systemctl start nessusagent.service 

rm -rf "$PT_nixfilepath"