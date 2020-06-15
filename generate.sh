#!/bin/bash

# go to the directory where the script is
cd $(dirname $0)

# ask for how many folder the user wants
echo "how many folders do you want to generate?"
read number_of_files

# clear up the old content folder in case it had stuff.
# deleting posts/* gives an error (file list too long) when there are more than 1024 test posts.
# so it is better to just delete posts and re-create it.
rm -f -R benchmark/content/posts/
 
# re-create content/posts , -p to be on the safe side.
mkdir -p benchmark/content/posts

#  show a message, otherwise it looks like the script is hanging
echo "working on it...."

# simple loop with cp command
i=1
while [[ $i -le $number_of_files ]]
do
	cp -R "sample-content" "benchmark/content/posts/post-"$i
	(( i=i+1 ))
done

echo "done!"
