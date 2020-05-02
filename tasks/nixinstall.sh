#!/bin/bash

echo $PT_action

install () {
    
    rpm -ivh "$PT_nixfilepath"

    # rm -rf "$PT_nixfilepath"
}

link () {

    /opt/nessus_agent/sbin/nessuscli agent link --host="$PT_host" --key="$PT_key" --port="$PT_port" --groups="$PT_groups"
    /bin/systemctl start nessusagent.service 

}

unlink () {

    /opt/nessus_agent/sbin/nessuscli agent unlink

}

if [ "$PT_action" = install ]
then
    install
    link
elif [ "$PT_action" = unlink ]
then    
    unlink
elif [ "$PT_action" = link ]
then
    link
else   
    echo "Please use a valid action.  Valid actions are install, link, or unlink"
fi
