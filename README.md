# Jekyll Test Cases

## Context

When publishing Jekyll sites on GitHub Pages, users are limited to a list of supported plugins. There are, however, solutions that are called [Github Actions](https://docs.github.com/en/actions) and use dedicated Docker images to build and deploy Jekyll sites and allow possibility to use any Jekyll plugins. One of the most famous ones is [helaili/jekyll-action](https://github.com/helaili/jekyll-action).

To deal with lossless compression image formats like WebP and Avif, I decided to integrate a remarkable Jekyll plugin [rbuchberger/jekyll_picture_tag](https://github.com/rbuchberger/jekyll_picture_tag), able to automatically builds cropped, resized, and reformatted images, and a lot of more.

But that's when I got into trouble...

Locally, on my mac, everything was working great: I must say I run the usual `bundle exec jekyll serve` command to build my site.
On the other hand, when I tried the Jekyll Actions solution, I encountered a very odd error: 
```Liquid Exception: stack level too deep (SystemStackError)``` 

So I decided to implement locally the way GitHub is actually building the Jekyll site. It's Docker after all! And, well, I ran into the same error.

Here it is and this allows me to have a reproductible test case.

## How-to build

To reproduce the case, you'll need to:
- Clone this repository locally,
- Have a Docker engine.

### Cloning

Well, enter:
```
git clone https://github.com/scalastic/jekyll-test-cases.git
```

### Building the Docker image

To build same-Jekyll-Actions as the one used in GitHub Actions:

- Go into the project directory:
```
cd jekyll-test-case
```

- Run the Docker build command:
```
docker build -t jekyll-test-actions -f Dockerfile .
```
That will build a local `jekyll-test-actions` docker image.

### Running the tests

To see where the problem lies, I made 3 examples of Jekyll sites:
1. ***jekyll-basic*** containing usual <img> balise with original picture format PNG.
1. ***jekyll-jpt-webp*** converting the PNG picture into WebP format.
1. ***jekyll-jpt-avif*** converting the PNG picture into WebP and Avif formats.

The `test.sh` script simply run the build of this 3 projects inside the docker image. 

To do so, execute:
```
./test.sh
```

### Results

