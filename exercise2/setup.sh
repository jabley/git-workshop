#!/bin/bash

git init

cat > .gitignore <<EOF
/README.md
/setup.sh
EOF
git add .gitignore
git commit -m "Add .gitignore"

echo "Test file 1" > file1
git add file1
git commit -m "Add file1"

echo "Test file 2" > file2
git add file2
git commit -m "Add file2"
