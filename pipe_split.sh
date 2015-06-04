cat pipe | split -l 1 - ff &
cat << EOF > pipe
a
b
c
d
e
EOF

