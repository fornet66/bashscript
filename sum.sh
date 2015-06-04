
cat sum.txt | awk 'BEGIN{total=0}{total+=$1}END{print total}'

cat sum.txt | echo $[ $( tr '\n' '+' ) 0]

