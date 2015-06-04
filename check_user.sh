#!/bin/bash

echo "You are logged in as `whoami`";

if [ `whoami` != xienan ]; then
  echo "Must be logged on as xienan to run this script."
  exit
fi

echo "Running script at `date`"

