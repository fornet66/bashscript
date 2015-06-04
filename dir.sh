
#!/bin/sh
dir=${1:-.}
(cd $dir;pwd)
du -k $dir| awk '{print $2, "== ("$1"kb)"}' |sort -f|sed -e "s,[^ /]*/\([^ /]*\) ==,|--\1," -e "s,[^ /]*/,| ,g"

