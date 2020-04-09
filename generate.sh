#!/bin/bash

# ask for how many folder the user wants
echo "how many folders do you want to generate?"
read number_of_files

# in case the directory doesn't exit. first run case scenario.
# -p argument takes care of checking if already exists or not.
mkdir -p content/posts

# clear up the old content folder in case it had stuff.
rm -f -R content/posts/*

# get started. here the message is to let the user know. otherwise it looks like the script is hanging
echo "working on it...."

# simple loop with cp command
i=0
while [[ $i -le $number_of_files ]]
do
	cp -R "clone" "content/posts/thread-"$i
	(( i=i+1 ))
done

echo "done!"
