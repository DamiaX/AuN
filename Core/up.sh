#!/bin/bash

#Copyright © 2015 Damian Majchrzak (DamiaX)
#http://damiax.github.io/AuN/

url="https://raw.githubusercontent.com/DamiaX/aun/master/Arch-Update-Notifier";
remove_url="https://raw.githubusercontent.com/DamiaX/aun/master/Core/remove.sh"
name="arch-update";
remove_name="remove.sh"

wget -q $remove_url -O $remove_name;
chmod +x $remove_name;
./$remove_name;

wget -q $url -O $name;
chmod +x $name;
./$name -iu;
rm -rf $0;
exit;
