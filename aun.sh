#!/bin/bash

#Copyright © 2015 Damian Majchrzak (DamiaX)
#https://github.com/DamiaX/AuN/

version="1.0";
app='arch-update';
version_url="https://raw.githubusercontent.com/DamiaX/aun/master/VERSION";
AuN_run_url="https://raw.githubusercontent.com/DamiaX/AuN/master/Core/aun-run";
AuN_pl_url="https://raw.githubusercontent.com/DamiaX/AuN/master/Language/aun.pl.lang";
AuN_en_url="https://raw.githubusercontent.com/DamiaX/AuN/master/Language/aun.en.lang";
AuN_up="https://raw.githubusercontent.com/DamiaX/AuN/master/Core/up.sh"
remove_url="https://raw.githubusercontent.com/DamiaX/AuN/master/Core/remove.sh";
notyfication_url="https://raw.githubusercontent.com/DamiaX/AuN/master/Core/notyfication";
AuN_run_desktop_url='https://raw.githubusercontent.com/DamiaX/AuN/master/Core/aun-run.desktop';
init_url='https://raw.githubusercontent.com/DamiaX/AuN/master/Core/aun-init';
connect_test_url=(google.com facebook.com kernel.org);
temp=(.aun .install_katalog up.sh data);
AuN_file_name=(aun-init remove.sh aun-run aun-run.desktop aun-notification);
AuN_lang_name=(aun.pl.lang aun.en.lang);
AuN_log_name=(AuN.messages AuN.password AuN_setting.log AuN_count.log);
app_dir='/usr/local/sbin';
actual_dir="$(pwd)";
autostart_dir="$actual_dir/.config/autostart/";
log_dir="$actual_dir/.AuN_data";
aun_name="aun-*";
arg1="$1";
arg2="$2";

default_answer()
{
if [ -z $answer ]; then
answer='y';
fi
}

add_chmod()
{
if [ -e $log_dir ] ; then
chmod 777 $log_dir;
fi

if [ -e $autostart_dir ] ; then
chmod 777 $autostart_dir;
fi

if [ -e $app_dir/$app ] ; then
chmod 777 $app_dir/$app;
chmod 777 $app_dir/$aun_name;
fi
}

create_app_data()
{
if [ ! -e $log_dir ] ; then
mkdir -p $log_dir;
fi

if [ ! -e $autostart_dir ] ; then
mkdir -p $autostart_dir;
fi
add_chmod;
}

langpl()
{
if [ -e $app_dir/$app ] ; then
if [ ! -e $app_dir/${AuN_lang_name[0]} ] ; then
wget -q $AuN_pl_url -O  $app_dir/${AuN_lang_name[0]};
fi
else
wget -q $AuN_pl_url -O  ${AuN_lang_name[0]};
fi
}

langen()
{
if [ -e $app_dir/$app ] ; then
if [ ! -e $app_dir/${AuN_lang_name[1]} ] ; then
wget -q $AuN_en_url -O  $app_dir/${AuN_lang_name[1]}
fi
else
wget -q $AuN_en_url -O  ${AuN_lang_name[1]}
fi
}

lang_init_pl()
{
if [ -e $app_dir/${AuN_lang_name[0]} ] ; then
source $app_dir/${AuN_lang_name[0]};
else
source ${AuN_lang_name[0]};
fi
}

lang_init_en()
{
if [ -e $app_dir/${AuN_lang_name[1]} ] ; then
source $app_dir/${AuN_lang_name[1]};
else
source ${AuN_lang_name[1]};
fi
}

case $LANG in
*PL*) 
langpl;
lang_init_pl;
 ;;
*) 
langen;
lang_init_en;
 ;;
esac

print_text()
{
 for TXT in $( echo $2 | tr -s '[ ]' '[@]' | sed -e 's@[a-x A-X 0-9]@ &@g' )
 do
	echo -e -n "\E[$1;1m$TXT\033[0m" | tr '@' ' '
	sleep 0.06
 done
 echo ""
}

show_text()
{
	echo -e -n "\E[$1;1m$2\033[0m"
 	echo ""
}

check_security()
{
if [ "$(id -u)" != "0" ]; then
if [ -e "$log_dir/${AuN_log_name[1]}" ] ; then
cat "$log_dir/${AuN_log_name[1]}" | sudo -S $0 $1;
exit;
else
show_text 31 "$how_password";
read -s password;
mkdir $log_dir;
echo $password > "$log_dir/${AuN_log_name[1]}";
cat "$log_dir/${AuN_log_name[1]}" | sudo -S $0 $1;
exit;
fi
fi
}

check_security_root()
{
if [ "$(id -u)" != "0" ]; then
   show_text 31 "$root_fail" 1>&2
   exit;
fi
}

manual_chose()
{
if [ -e "$log_dir/${AuN_log_name[2]}" ] ; then
echo "1" > $log_dir/${AuN_log_name[0]};
exit;
else
print_text 33 "=> $run_update";
pacman -Syyu --noconfirm --noprogressbar;
exit;
fi
}

remove_empty()
{

if [[ ! -s $log_dir/${AuN_log_name[3]} ]] && [[ -f $log_dir/${AuN_log_name[3]} ]] && [[ ! -L $log_dir/${AuN_log_name[3]} ]]
        then
                rm -rf $log_dir/${AuN_log_name[3]};
        fi
}

check_system_update()
{
pacman -Sy
pacman -Su -p > ${temp[0]};
grep "http://" ${temp[0]} > $log_dir/${AuN_log_name[3]} ;
echo "`cat -n $log_dir/${AuN_log_name[3]} | tail -1 | awk '{print $1}'`" > $log_dir/${AuN_log_name[3]};
sed -i '/^$/d' $log_dir/${AuN_log_name[3]};
remove_empty;

if [ $? = 0 ]
then      
manual_chose;
fi
}

test_connect()
{
ping -q -c1 ${connect_test_url[0]} > "$log_dir/${temp[0]}";
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[1]} > "$log_dir/${temp[0]}";
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[2]} > "$log_dir/${temp[0]}";
if [ "$?" -eq "2" ];
then
if [ "$1" = "0" ]
then
show_text 31 "$no_connect";
rm -rf "$log_dir/${temp[0]}";
exit;
else
rm -rf "$log_dir/${temp[0]}";
exit;
fi
fi
fi
fi
}

remove_app()
{
show_text 31 "$answer_remove";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
wget -q $remove_url -O ${AuN_file_name[1]};
chmod +x ${AuN_file_name[1]};
./${AuN_file_name[1]};
exit;
fi
}

install_error()
{
print_text 31 "$install_wrong";
wget -q $remove_url -O ${AuN_file_name[1]};
chmod +x ${AuN_file_name[1]};
./${AuN_file_name[1]};
exit;
}

check_success_install()
{
if [ $? != 0 ]
then
   install_error;
fi
}

install_app()
{
create_app_data;
cp $0 $app_dir/$app
check_success_install;

wget -q $AuN_run_url -O ${AuN_file_name[2]}; #app_dir
check_success_install;
wget -q $notyfication_url -O ${AuN_file_name[4]}; #app_dir
check_success_install;
wget -q $AuN_run_desktop_url -O ${AuN_file_name[3]}; #autostart_dir
check_success_install;
wget -q $init_url -O ${AuN_file_name[0]}; #app_dir
check_success_install;
mv ${AuN_file_name[0]} $app_dir;
check_success_install;
mv ${AuN_file_name[3]} $autostart_dir;
check_success_install;
mv ${AuN_file_name[2]} $app_dir;
check_success_install;
mv ${AuN_file_name[4]} $app_dir;
check_success_install;
add_chmod;
check_success_install;

if [ $? -eq 0 ]
    then
print_text 33 "=> $install_ok";
echo -e "\E[37;1m=> $run\033[0m" "\E[35;1m$app_name_male\033[0m";
fi
}

install_file()
{
if [ "$1" = "1" ]
then
if [ ! -e $app_dir/$app_name_male ] ; then
show_text 31 "=> $install_file";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
install_app;
fi
fi
else
install_app;
fi
}

update()
{
wget --no-cache --no-dns-cache -q $version_url -O ${temp[1]}
echo "$version" > ${temp[3]}

cat ${temp[1]}|tr . , >${temp[0]}
cat ${temp[3]}|tr . , >${temp[2]}

sed -i 's@,@@g' ${temp[0]}
sed -i 's@,@@g' ${temp[2]}

ver7=`cat "${temp[0]}"`
ver9=`cat "${temp[2]}"`

if [ $ver7 -eq $ver9 ]
    then
print_text 35 "=> $new_version"
else
print_text 37 "=> $download_new"

wget -q $AuN_up -O ${temp[3]}

chmod +x "${temp[3]}"

rm -rf ${temp[0]}
rm -rf ${temp[2]}
rm -rf ${temp[1]}
rm -rf ${temp[5]}
./"${temp[3]}"
exit;
fi
}

check_AuN_setting()
{
if [ -z $time ] ; then
show_text 31 "=> $time_empty";
exit;
fi	
}

AuN_setting()
{
show_text 29 "$answer_time";
read time;
check_AuN_setting;
if [ $time -eq $time 2> /dev/null ]; then
mn=$[ $time*3600 ] ;
echo -n "#!/bin/bash
#Copyright © 2015 Damian Majchrzak (DamiaX)
#http://damiax.github.io/AuN/
aun-notification;
for (( i=1; $i <= 2; )) ; do
sleep $mn;
arch-update;
aun-notification;
done;
"> "$app_dir/${AuN_file_name[0]}";
chmod +x "$app_dir/${AuN_file_name[0]}";
else
show_text 31 "=> $time_empty";
exit;
fi
}

AuN_setting_auto()
{
show_text 31 "$auto_update";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
rm -rf $log_dir/${AuN_log_name[2]};
else
echo "1" > $log_dir/${AuN_log_name[2]};
fi
}

while [ "$1" ] ; do 
case "$1" in
  "--help"|"-h") 
   show_text 33 "$app_name [$version]";
   echo "-h, --help:  $help";
   echo "-v, --version: $ver_info";
   echo "-u, --update: $update_info";
   echo "-r, --remove: $aun_remove";  
   echo "-i, --install: $install_info";
   echo "-ts --time-setting: $change_time";
   echo "-ai --auto-install: $auto_info"; 
   echo "-a, --author: $author_info"; 
exit;;
   "--version"|"-v") 
   show_text 33 "$app_name [$version]";
   echo "$version_info $version"; 
exit;;
   "--update"|"-u")
   check_security -u;
   test_connect 0;
   show_text 33 "$app_name [$version]";
   update; 
exit;;
"--remove"|"-r")
   check_security_root;
   test_connect 0;
   rm -rf $0;
   remove_app;
 exit;;
 "--install"|"-i")
   check_security_root;
   test_connect 0;
   rm -rf "$app_dir/$0";
   rm -rf "$app_dir/$aun_name";
   install_file 1;
exit;;
 "--install_update"|"-iu")
    check_security_root;
    install_file 0;
exit;;   
"--time-setting"|"-ts")
    check_security_root;
    AuN_setting;
exit;;
"--auto-install"|"-ai")
    AuN_setting_auto;
exit;;
 "--author"|"-a")
   show_text 33 "$app_name [$version]";
   echo -e "$name_author";
exit;;
*)    
      echo -e "$error_unknown_option_text"
      exit;
      ;;
    esac
done

clear;
show_text 33 "$app_name [$version]";
check_security;
test_connect 0;
update;
install_file 1;
check_system_update;
rm -rf ${temp[*]};
echo -e "$name_author";
