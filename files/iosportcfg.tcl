ios_config "interface gi0/3" "no shutdown"
ios_config "interface gi0/2" "no shutdown"
ios_config "vlan 200" "name engineering"
ios_config "interface gi0/1" "switchport mode" "switchport access vlan 200" "no shutdown"
ios_config "copy running-config startup-config"