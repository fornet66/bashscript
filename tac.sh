
seq 9 | \
awk '{ lifo[NR]=$0; lno=NR }
END{ for(;lno>-1;lno--) { print lifo[lno]; }
}'

