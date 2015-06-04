#!/bin/bash

for ip in 10.1.251.{1..255} ;
do
  ping $ip -c 2 & > /dev/null;
  if [ $? -eq 0 ];
  then
    echo -e "\033[1;32m $ip is alive \033[0m"
  fi
done

