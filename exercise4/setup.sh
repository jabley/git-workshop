#!/bin/bash

git init

cat > .gitignore <<EOF
/README.md
/setup.sh
EOF
git add .gitignore
git commit -m "Add .gitignore"

cat > build.gradle <<'EOF'
plugins {
	id 'org.springframework.boot' version '2.4.1'
	id 'io.spring.dependency-management' version '1.0.10.RELEASE'
	id 'java'
}

group = 'com.example'
version = '1.5.7-SNAPSHOT'

task callScript(type: Exec) {
    commandLine './application.sh'
}
EOF

cat > application.sh <<'EOF'
#!/bin/bash

function hello() {
    wrong-echo "Hello $1!"
}

function goodbye() {
    echo "Goodbye $1!"
}

hello world

hello everyone

EOF

git add build.gradle application.sh
git commit -m "Add application files"

git checkout -b feature/say-goodbye-to-everyone
echo "goodbye everyone" >> application.sh
sed -i "s/^version = .*$/version = '1.6.0-SNAPSHOT'/" build.gradle
git add build.gradle application.sh
git commit -m "Say goodbye to everyone"
git checkout -
sed -i 's/wrong-echo/echo/' application.sh
sed -i "s/^version = .*$/version = '1.5.8-SNAPSHOT'/" build.gradle
git add build.gradle application.sh
git commit -m "Fix hello's echo command"
git merge -Xtheirs feature/say-goodbye-to-everyone -m "Merge branch 'feature/say-goodbye-to-everyone' into main"
