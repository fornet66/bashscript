#!/bin/sh
year=`date +%Y`
month=`date +%m`
day=`date +%d`
month=`expr $month + 0`
day=`expr $day - 1`
if [ $day -eq 0 ]; then
    month=`expr $month - 1`
    if [ $month -eq 0 ]; then
        month=12
        day=31
        year=`expr $year - 1`
    else
        case $month in
            1|3|5|7|8|10|12) day=31;;
            4|6|9|11) day=30;;
            2)
                if [ `expr $year % 4` -eq 0 ]; then
                    if [ `expr $year % 400` -eq 0 ]; then
                        day=29
                    elif [ `expr $year % 100` -eq 0 ]; then
                        day=28
                    else
                        day=29
                     fi
               else
                     day=28	
               fi
               ;;
         esac
    fi
fi
if [ $day -gt 0 -a $day -lt 10 ]; then
    day=0${day}
fi
echo $year$month$day

