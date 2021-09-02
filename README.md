# README 

[Hugo](https://gohugo.io/) is an open source static site generator implemented in golang. According to Hugo's website, it is the world's fastest framework for building sites.

This repo has scripts for benchmarking how fast hugo really is. The test results are generated as a csv file.

The main goals are to:
- measure how fast hugo really is, compare it to other site generators, 
- compare the different versions within hugo, to see if changes over time are slowing it down,  
- measure the build time for different themes,
- measure the efficiency of optimizing a theme, tweaking the infrastructure and build parameters.

A fun side goal is to:

- measure the impact of that speed on savings in CO2 emissions. This is applicable for really large scale projects like building all of github pages by using hugo instead of jekyll.   

**Operating system:**  
The scripts will not work on Windows. They were tested on macOS (bash and zsh) and Ubuntu.

# Repo structure

- `sample-content/`: a directory with a sample post and 5 images. It is meant to represent an "average" post. 
- `data/`: a directory where the test results are.
- `benchmark/`: what's actually getting benchmarked: a hugo site, configuration, content and theme. 
- `generate.sh`: a script that generates content for the test. It prompts the user how many times they want to clone the `sample-content` directory.   
- `run_test.sh`: the script that runs the test and saves the output as csv file with a time stamp in `data/`.

# How to run 

**TLDR**:

Make sure scripts are executable (one time only):
- `chmod +x generate.sh`
- `chmod +x run_test.sh`

Make sure your hugo installation works (one time only):
- `cd benchmark`
- `git submodule init`
- `git submodule update`
- `hugo`
- check if hugo build worked
- `cd ..`

then

- `./generate.sh`
- `./run_test.sh`

---
## Details 

### Generate dummy content

Generate dummy content by running the script `generate.sh`. It will prompt you to enter how many copies you want. 

The script will take whatever is in `sample-content` and clone it x number of times and save the output to `content/posts`

Make sure the script has the right permissions then run it by using the following commands:  

- `chmod +x generate.sh`
- `./generate.sh`

The target directory where the files are generated is `benchmark/content/posts`. 

### Check your hugo install

Install Hugo. Follow instructions on [https://gohugo.io/getting-started/installing/](https://gohugo.io/getting-started/installing/) 

Make sure you have hugo running and double check that the theme is working.

- `cd benchmark`
- `git submodule init`
- `git submodule update`
- `hugo` or `hugo server`

This repo is configured with the default hugo theme " Ananke" featured in this [quick start](https://gohugo.io/getting-started/quick-start/).

### Run the tests

The commands are: 

- `chmod +x run_test.sh`
- `./run_test.sh`

The script `run_test` will prompt you for:
- how many times you want to run `hugo build`. 
- time to wait between the runs.

The time it takes for a build changes slightly between runs even on the same machine, so you might want to do a couple of runs to get a good average. Numbers will vary wildly based on your hugo cache settings. 

The time to wait between runs lets your machine cool off and eases the pressure off the memory. It creates more "fair" measurments.

The output is saved as a csv file with a time stamp in the data directory. 

#### Hugo output:  

![hugo output](docs/hugo-screenshot.png)  

#### CSV file:  

Columns:  
- datetime
- cpus
- cpu-type
- free-ram
- pages
- paginator-pages
- static-files
- non-page
- total-time-milliseconds


#### Hardware specs 

CPU count was generated with:  

```bash 
cpus=$(getconf _NPROCESSORS_ONLN)
```

CPU type and free ram were generated with: 

``` bash 
os=$(echo OSTYPE)
if [ "$os" = "linux-gnu" ]; then
    cpu_type=$(cat /proc/cpuinfo | grep 'model name' | uniq | grep -o "CPU.*")  
    free_ram=$(free -m  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 4)   
else
    cpu_type=$(sysctl -n machdep.cpu.brand_string)  
    free_ram=$(top -l 1 | grep PhysMem: | awk '{print $6}')  
fi
```

Double check these commands when the script runs on different operating systems or releases.

# Existing benchmark

Existing benchmark do say that hugo is pretty fast. But it is unclear what the specs of the machine used in building were or which version.

### Hugo vs Jekyll benchmark
https://forestry.io/blog/hugo-vs-jekyll-benchmark/

**Simple posts**  
Posts included a title, date and lorem lipsum.
![simple](docs/simple-benchmark.png)

**Posts with categories, tags, archive pages**  
Posts included both tags and categories and the build generated XML sitemap and RSS feed.

![advanced](docs/advanced-benchmark.png)

## Useful links.

- Hugo build performance: https://gohugo.io/troubleshooting/build-performance/
- Hugo vs Jekyll benchmark: https://forestry.io/blog/hugo-vs-jekyll-benchmark/