#!/bin/bash

rpm -ivh "$PT_nixfilepath"
/opt/nessus_agent/sbin/nessuscli agent link --host="$PT_host" --key="$PT_key" --port="$PT_port"
/bin/systemctl start nessusagent.service 

rm -rf "$PT_nixfilepath"