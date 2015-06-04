#!/bin/bash

stty -echo    
echo -n "Enter the database system password:  "
read pw
stty echo

echo "$pw was entered"

