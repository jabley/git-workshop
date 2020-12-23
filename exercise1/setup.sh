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
git commit -m "Commit 1" --no-gpg-sign # --no-gpg-sign is included to make the raw files in the exercise easier to read

echo "Test file 2" > file2
git add file2
git commit -m "Commit 2" --no-gpg-sign # --no-gpg-sign is included to make the raw files in the exercise easier to read
