#!/bin/bash
for d in *
do
	if [ -d "$d" -a "$d" != "CVS" ]; then
		if [ ! -d "$d/CVS" ]; then
			cvs add "$d"
		fi
		cvs add $(ls $d/*.{h,c,hpp,cpp,java,html,xml,sh,mk} $d/Makefile 2>/dev/null)
	fi
done
cvs commit

