#!/bin/bash

# ask for how many folder the user wants
echo "how many folders do you want to generate?"
read number_of_files

# created the content/posts in case the directory doesn't exit (first run)
# -p argument takes care of checking if already exists or not.
mkdir -p content/posts

# clear up the old content folder in case it had stuff.
rm -f -R content/posts/*

#  show a message, otherwise it looks like the script is hanging
echo "working on it...."

# simple loop with cp command
i=0
while [[ $i -le $number_of_files ]]
do
	cp -R "sample-content" "content/posts/post-"$i
	(( i=i+1 ))
done

echo "done!"
