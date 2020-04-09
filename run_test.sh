#!/bin/bash

# get the specs of the machine and time.
datetime=$(date +"%Y-%m-%d %T")
cpus=$(nproc)
cpu_type=$(cat /proc/cpuinfo | grep 'model name' | uniq | grep -o "CPU.*")
free_ram=$(free -m  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 4)

# make a data directory in case it doesn't exist
mkdir -p data

# run once, create the file with the header
filename=data/results-$datetime.csv

echo datetime, cpus, cpu-type, free-ram, pages, paginator-pages, static-files, non-page, total > "$filename"

echo "how many times do you want to run?"
read number_of_runs

echo "Taking a break will ensure that tests are more fair. How long are you willing two wait between runs? enter a number in seconds"
read sleep_duration

i=1
while [[ $i -le $number_of_runs ]]
do

    echo run number: "$i"
    # go into the benchmark folder and run hhugo command.
    cd benchmark

    # use grep to grab only what's after specific keywords
    # hugo | grep -o 'Total in.*'  will return: Total in 559 ms
    # the keywords are what shows up after you run hugo on command line
    # in hugo's case, it is pages, paginator pages, static files etc..
    # \| allows grepping for multiple strings
    # the result of the first grep are passed into another one
    # grep -Eo [0-9]+ -- this grabs only the number
    # both greps give us the results but each is on a new line
    # use tr which stands for translate or delete characters to replace \n with a comma.
    # here, the outcome has an extra comma at the end, but we cut it using -1 in the next step.  
    hugo=$(hugo | grep -o 'Pages.*\|Total in.*\|Paginator pages.*\|Static files.*\|Non-page.*' | grep -Eo [0-9]+ | tr '\n' ',')

    cd .. 

    echo "$datetime","$cpus","$cpu_type","$free_ram","${hugo:0:-1}" >> "$filename"

    sleep "$sleep_duration"
    (( i=i+1 ))

done

echo "done!"
