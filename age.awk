
realage=$1
echo "$(awk '{if ($5<AGE) printf("%s\n",$0); }' AGE=$realage ./age.txt)"

