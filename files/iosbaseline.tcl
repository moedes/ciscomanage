ios_config "ip name-server 192.168.25.14"
ios_config "ip name-server 192.168.25.110"
ios_config "ip domain list puppet.demo"
ios_config "clock timezone EST -5"
ios_config "clock summer-time EDT recurring"
ios_config "no ntp server 192.168.25.110"
ios_config "interface GigabitEthernet 0/0" "ntp broadcast"
