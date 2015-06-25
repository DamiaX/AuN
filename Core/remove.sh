
#!/bin/bash

#Copyright © 2015 Damian Majchrzak (DamiaX)
#http://damiax.github.io/AuN/

temp=".temp";

ps -e | grep 'aun-init' >$temp

if [ -s $temp ]
 then
killall 'sleep'; 
killall aun-init;
fi

sudo rm -rf /tmp/aun*; 
sudo rm -rf /usr/share/icons/hicolor/128x128/apps/aun.png; 
sudo rm -rf ~/.config/autostart/aun*;
sudo rm -rf /usr/local/sbin/aun*; 
sudo rm -rf /usr/share/applications/aun*;
sudo rm -rf $HOME/.AuN_data;
sudo rm -rf aun*; 
rm -rf $temp;

sudo rm -rf $0;

exit;
