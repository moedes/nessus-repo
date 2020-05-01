#!/bin/bash

echo $PT_action

install () {
    
    rpm -ivh "$PT_nixfilepath"
    /opt/nessus_agent/sbin/nessuscli agent link --host="$PT_host" --key="$PT_key" --port="$PT_port" --groups="Linux Servers - Mozes"
    /bin/systemctl start nessusagent.service 

    # rm -rf "$PT_nixfilepath"
}

unlink () {

    /opt/nessus_agent/sbin/nessuscli agent unlink

}

if [ "$PT_action" = install ]
then
    install
elif [ "$PT_action" = unlink ]
then    
    unlink
else   
    echo "Please use a valid action.  Valid actions are install or unlink"
fi

