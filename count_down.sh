
#!/bin/bash -xv
read -p "input countdown second(s):" count
echo -n Conut:
tput sc
while true;
do
if [ $count -le $count ]
then
  let count--
  sleep 1;
  tput rc
  tput ed
  echo -n -e "\e[1;31m${count}\e[0m "
else
  exit 0;
fi
if [ $count -eq 0 ]
then
  echo ""
  break;
fi
done

