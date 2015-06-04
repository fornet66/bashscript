
#!/bin/bash
clear
col=`tput cols`
line=`tput lines`
color=(31 32 33 34 35 36 37)
while true;
do
scol=`expr $RANDOM % $col`
sline=`expr $RANDOM % $line`
tput cup $sline $scol
echo -e "\e[1;${color[`expr $RANDOM % 7`]}m . \e[0m"
done

