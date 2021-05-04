# Jekyll Test Cases

## Context

When publishing Jekyll sites on GitHub Pages, users are limited to a list of supported plugins. There are, however, solutions that are called [Github Actions](https://docs.github.com/en/actions) and use dedicated Docker images to build and deploy Jekyll sites and allow possibility to use any Jekyll plugins. One of the most famous ones is [helaili/jekyll-action](https://github.com/helaili/jekyll-action).

To deal with lossless compression image formats like WebP and Avif, I decided to integrate a remarkable Jekyll plugin [rbuchberger/jekyll_picture_tag](https://github.com/rbuchberger/jekyll_picture_tag), able to automatically builds cropped, resized, and reformatted images, and a lot of more.

But that's when I got into trouble...

- Locally, on my mac, everything was working great: I must say I run the usual `bundle exec jekyll serve` command to build my site.
- On the other hand, when I tried the Jekyll Actions solution, I encountered a very odd error: 
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
1. **jekyll-basic**: basic Jekyll site containing usual `<img>` balise with original picture format PNG.
1. **jekyll-jpt-webp**: Jekyll site with `jekyll_picture_tag` plugin converting the PNG picture into WebP format.
1. **jekyll-jpt-avif**: Jekyll site with `jekyll_picture_tag` plugin converting the PNG picture into WebP and Avif formats.

The `run-tests.sh` script simply run the build of this 3 projects inside the docker image. 

To do so, execute:
```
./run-tests.sh
```

### Results

The test failed at step #3 when starting to convert image into Avif format:
```
Warning: the running version of Bundler (2.1.4) is older than the version that created the lockfile (2.2.16). We suggest you to upgrade to the version that created the lockfile by running `gem install bundler:2.2.16`.
Project jekyll-basic build: SUCCESS ✅
Warning: the running version of Bundler (2.1.4) is older than the version that created the lockfile (2.2.16). We suggest you to upgrade to the version that created the lockfile by running `gem install bundler:2.2.16`.
Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
Jekyll Picture Tag Warning: /assets/img/logo.png is smaller than the requested fallback width of 800px. Using 640 px instead.
Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
Jekyll Picture Tag Warning: /assets/img/logo.png is smaller than the requested fallback width of 800px. Using 640 px instead.
Project jekyll-jpt-webp build: SUCCESS ✅
Warning: the running version of Bundler (2.1.4) is older than the version that created the lockfile (2.2.16). We suggest you to upgrade to the version that created the lockfile by running `gem install bundler:2.2.16`.
Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
  Liquid Exception: stack level too deep in /github/workspace/jekyll-jpt-avif/_layouts/default.html
                    ------------------------------------------------
      Jekyll 4.2.0   Please append `--trace` to the `build` command 
                     for any additional information or backtrace. 
                    ------------------------------------------------
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187:in `vips_cache_operation_build': stack level too deep (SystemStackError)
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187:in `build'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:402:in `call'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/image.rb:469:in `write_to_file'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:74:in `write'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:35:in `build'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:19:in `initialize'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb:81:in `new'
  from /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb:81:in `generate_image'
   ... 71 levels...
  from /usr/local/lib/ruby/2.7.0/bundler/friendly_errors.rb:123:in `with_friendly_errors'
  from /usr/local/lib/ruby/gems/2.7.0/gems/bundler-2.1.4/libexec/bundle:34:in `<top (required)>'
  from /usr/local/bin/bundle:23:in `load'
  from /usr/local/bin/bundle:23:in `<main>'
Project jekyll-jpt-avif build: FAILED ❌
```

### Question

Where does the problem come from?

Well, I don't know and I will ask the mainteners of `jekyll-action` and  `jekyll_picture_tag` projects!
