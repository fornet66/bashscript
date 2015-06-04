
echo -e "aaa\n\n\nbbb\n\nccc\n\nddd" | sed '/^$/d'

echo this is an example | sed 's/\w\+/[&]/g'

echo hello world | sed "s/$text/HELLO/"

