#!/bin/bash

doContinue=n
echo "Do you really want to continue? (y/n)" 
read doContinue

if [ "$doContinue" != "y" ] && [ "$doContinue" != "Y" ]; then
  echo "Quitting..."
  exit
fi
echo "OK... we will continue."

