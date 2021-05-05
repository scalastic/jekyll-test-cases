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

===================================
Project jekyll-basic build: SUCCESS ✅
Generated site in: ./build/jekyll-basic/
===================================

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

===================================
Project jekyll-jpt-webp build: SUCCESS ✅
Generated site in: ./build/jekyll-jpt-webp/
===================================

Jekyll Picture Tag Warning: /assets/img/logo.png
is 640px wide (after cropping, if applicable),
smaller than at least one size in the set [400, 600, 800, 1000].
Will not enlarge.
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187: [BUG] Segmentation fault at 0x0000000000000000
ruby 2.7.3p183 (2021-04-05 revision 6847ee089d) [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
c:0085 p:---- s:0488 e:000487 CFUNC  :vips_cache_operation_build
c:0084 p:0012 s:0483 e:000482 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187
c:0083 p:0357 s:0478 e:000477 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:402
c:0082 p:0134 s:0461 e:000460 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/image.rb:469
c:0081 p:0043 s:0452 e:000451 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_fi
c:0080 p:0025 s:0447 e:000446 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_fi
c:0079 p:0013 s:0442 e:000441 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_fi [FINISH]
c:0078 p:---- s:0436 e:000435 CFUNC  :new
c:0077 p:0024 s:0430 e:000429 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generate
c:0076 p:0017 s:0426 e:000425 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generate [FINISH]
c:0075 p:---- s:0422 e:000421 CFUNC  :each
c:0074 p:0026 s:0418 e:000417 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.r
c:0073 p:0017 s:0413 e:000412 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.r
c:0072 p:0003 s:0409 e:000408 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.r
c:0071 p:0003 s:0405 e:000404 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.r
c:0070 p:0007 s:0401 e:000398 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/
c:0069 p:0052 s:0393 e:000392 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/
c:0068 p:0006 s:0387 e:000386 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/ [FINISH]
c:0067 p:---- s:0383 e:000382 CFUNC  :collect
c:0066 p:0006 s:0379 e:000378 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/
c:0065 p:0028 s:0375 e:000371 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/
c:0064 p:0004 s:0367 e:000365 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/
c:0063 p:0066 s:0362 e:000361 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag.rb:71
c:0062 p:0010 s:0357 e:000356 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:103
c:0061 p:0112 s:0346 e:000345 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:91
c:0060 p:0019 s:0338 e:000337 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:46 [FINISH]
c:0059 p:---- s:0334 e:000333 CFUNC  :each
c:0058 p:0007 s:0330 e:000329 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:44
c:0057 p:0032 s:0327 e:000326 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/context.rb:123
c:0056 p:0005 s:0321 e:000320 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:43
c:0055 p:0010 s:0316 e:000315 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:103
c:0054 p:0169 s:0305 e:000304 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:82
c:0053 p:0008 s:0297 e:000296 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:208
c:0052 p:0075 s:0294 e:000293 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:242
c:0051 p:0345 s:0289 e:000288 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:207
c:0050 p:0012 s:0278 e:000277 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:220
c:0049 p:0011 s:0273 e:000272 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:39
c:0048 p:0011 s:0270 e:000269 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:59
c:0047 p:0005 s:0266 e:000265 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:38
c:0046 p:0002 s:0263 e:000262 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:63
c:0045 p:0005 s:0259 e:000258 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:37
c:0044 p:0015 s:0256 e:000255 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:70
c:0043 p:0008 s:0250 e:000249 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:36
c:0042 p:0035 s:0245 e:000244 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:131
c:0041 p:0062 s:0235 e:000234 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:194
c:0040 p:0070 s:0228 e:000227 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:163
c:0039 p:0204 s:0218 e:000217 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:93
c:0038 p:0072 s:0212 e:000211 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:63
c:0037 p:0028 s:0208 e:000206 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:547
c:0036 p:0008 s:0201 e:000200 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:539 [FINISH]
c:0035 p:---- s:0197 e:000196 CFUNC  :each
c:0034 p:0006 s:0193 e:000192 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:538
c:0033 p:0043 s:0188 e:000187 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:211
c:0032 p:0030 s:0183 e:000182 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:80
c:0031 p:0004 s:0179 e:000178 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:28
c:0030 p:0142 s:0173 e:000172 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:65
c:0029 p:0079 s:0163 e:000162 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:36
c:0028 p:0015 s:0157 e:000156 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:91 [FINISH]
c:0027 p:---- s:0153 e:000152 CFUNC  :each
c:0026 p:0005 s:0149 e:000148 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:91
c:0025 p:0018 s:0139 e:000138 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:18
c:0024 p:0009 s:0134 e:000133 BLOCK  /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb:221 [FINISH]
c:0023 p:---- s:0130 e:000129 CFUNC  :each
c:0022 p:0036 s:0126 e:000125 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb:221
c:0021 p:0088 s:0120 e:000119 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/program.rb:44
c:0020 p:0033 s:0113 e:000112 METHOD /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary.rb:21
c:0019 p:0102 s:0107 E:000a20 TOP    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/exe/jekyll:15 [FINISH]
c:0018 p:---- s:0104 e:000103 CFUNC  :load
c:0017 p:0112 s:0099 e:000098 TOP    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/bin/jekyll:23 [FINISH]
c:0016 p:---- s:0094 e:000093 CFUNC  :load
c:0015 p:0107 s:0089 e:000088 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb:63
c:0014 p:0071 s:0083 e:000082 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb:28
c:0013 p:0024 s:0078 e:000077 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:494
c:0012 p:0054 s:0073 e:000072 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/command.rb:27
c:0011 p:0040 s:0065 e:000064 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/invocation.rb:127
c:0010 p:0239 s:0058 e:000057 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor.rb:392
c:0009 p:0008 s:0045 e:000044 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:30
c:0008 p:0066 s:0040 e:000039 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/base.rb:485
c:0007 p:0008 s:0033 e:000032 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:24
c:0006 p:0109 s:0028 e:000027 BLOCK  /usr/local/bundle/gems/bundler-2.2.16/exe/bundle:49
c:0005 p:0014 s:0022 e:000021 METHOD /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/friendly_errors.rb:130
c:0004 p:0162 s:0017 E:0024b8 TOP    /usr/local/bundle/gems/bundler-2.2.16/exe/bundle:37 [FINISH]
c:0003 p:---- s:0013 e:000012 CFUNC  :load
c:0002 p:0112 s:0008 E:0012d0 EVAL   /usr/local/bundle/bin/bundle:23 [FINISH]
c:0001 p:0000 s:0003 E:000bd0 (none) [FINISH]

-- Ruby level backtrace information ----------------------------------------
/usr/local/bundle/bin/bundle:23:in `<main>'
/usr/local/bundle/bin/bundle:23:in `load'
/usr/local/bundle/gems/bundler-2.2.16/exe/bundle:37:in `<top (required)>'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/friendly_errors.rb:130:in `with_friendly_errors'
/usr/local/bundle/gems/bundler-2.2.16/exe/bundle:49:in `block in <top (required)>'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:24:in `start'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/base.rb:485:in `start'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:30:in `dispatch'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor.rb:392:in `dispatch'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/invocation.rb:127:in `invoke_command'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/command.rb:27:in `run'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb:494:in `exec'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb:28:in `run'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb:63:in `kernel_load'
/usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb:63:in `load'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/bin/jekyll:23:in `<top (required)>'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/bin/jekyll:23:in `load'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/exe/jekyll:15:in `<top (required)>'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary.rb:21:in `program'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/program.rb:44:in `go'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `execute'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `each'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `block in execute'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:18:in `block (2 levels) in init_with_program'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:91:in `process_with_graceful_fail'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:91:in `each'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:91:in `block in process_with_graceful_fail'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:36:in `process'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb:65:in `build'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb:28:in `process_site'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:80:in `process'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:211:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:538:in `render_pages'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:538:in `each'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:539:in `block in render_pages'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb:547:in `render_regenerated'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:63:in `run'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:93:in `render_document'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:163:in `place_in_layouts'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:194:in `render_layout'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb:131:in `render_liquid'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:36:in `render!'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:70:in `measure_time'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:37:in `block in render!'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:63:in `measure_bytes'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:38:in `block (2 levels) in render!'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:59:in `measure_counts'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb:39:in `block (3 levels) in render!'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:220:in `render!'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:207:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:242:in `with_profiling'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb:208:in `block in render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:82:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:103:in `render_node_to_output'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:43:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/context.rb:123:in `stack'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:44:in `block in render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:44:in `each'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb:46:in `block (2 levels) in render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:91:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb:103:in `render_node_to_output'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag.rb:71:in `render'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/basic.rb:10:in `to_s'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb:66:in `base_markup'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb:26:in `build_sources'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb:26:in `collect'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb:26:in `block in build_sources'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb:39:in `build_source'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/basic.rb:57:in `add_srcset'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb:36:in `to_s'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb:32:in `to_a'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb:28:in `files'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb:71:in `build_files'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb:71:in `each'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb:25:in `generate'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb:81:in `generate_image'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb:81:in `new'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:19:in `initialize'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:35:in `build'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb:74:in `write'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/image.rb:469:in `write_to_file'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:402:in `call'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187:in `build'
/github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb:187:in `vips_cache_operation_build'

-- Machine register context ------------------------------------------------
 RIP: 0x00007f8fee190c59 RBP: 0x0000000000000000 RSP: 0x00007ffef1625a60
 RAX: 0x00007f8fe49afffc RBX: 0x0000000000032010 RCX: 0x0000000000000000
 RDX: 0x000000000000090c RDI: 0x00007f8fe497d010 RSI: 0x0000000000032fec
  R8: 0x00007f8fe49af6f0  R9: 0x00007f8fe497d6e0 R10: 0x0000000000000000
 R11: 0x0000000000000246 R12: 0x00005622c06212e8 R13: 0x00007f8fe4cfe720
 R14: 0x00007ffef1626020 R15: 0x0000000000000001 EFL: 0x0000000000010202

-- Other runtime information -----------------------------------------------

* Loaded script: /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/bin/jekyll

* Loaded features:

    0 enumerator.so
    1 thread.rb
    2 rational.so
    3 complex.so
    4 ruby2_keywords.rb
    5 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
    6 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
    7 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/rbconfig.rb
    8 /usr/local/lib/ruby/2.7.0/rubygems/compatibility.rb
    9 /usr/local/lib/ruby/2.7.0/rubygems/defaults.rb
   10 /usr/local/lib/ruby/2.7.0/rubygems/deprecate.rb
   11 /usr/local/lib/ruby/2.7.0/rubygems/errors.rb
   12 /usr/local/lib/ruby/2.7.0/rubygems/version.rb
   13 /usr/local/lib/ruby/2.7.0/rubygems/requirement.rb
   14 /usr/local/lib/ruby/2.7.0/rubygems/platform.rb
   15 /usr/local/lib/ruby/2.7.0/rubygems/basic_specification.rb
   16 /usr/local/lib/ruby/2.7.0/rubygems/stub_specification.rb
   17 /usr/local/lib/ruby/2.7.0/rubygems/util.rb
   18 /usr/local/lib/ruby/2.7.0/rubygems/text.rb
   19 /usr/local/lib/ruby/2.7.0/rubygems/user_interaction.rb
   20 /usr/local/lib/ruby/2.7.0/rubygems/specification_policy.rb
   21 /usr/local/lib/ruby/2.7.0/rubygems/util/list.rb
   22 /usr/local/lib/ruby/2.7.0/rubygems/specification.rb
   23 /usr/local/lib/ruby/2.7.0/rubygems/exceptions.rb
   24 /usr/local/lib/ruby/2.7.0/rubygems/bundler_version_finder.rb
   25 /usr/local/lib/ruby/2.7.0/rubygems/dependency.rb
   26 /usr/local/lib/ruby/2.7.0/rubygems/core_ext/kernel_gem.rb
   27 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
   28 /usr/local/lib/ruby/2.7.0/monitor.rb
   29 /usr/local/lib/ruby/2.7.0/rubygems/core_ext/kernel_require.rb
   30 /usr/local/lib/ruby/2.7.0/rubygems/core_ext/kernel_warn.rb
   31 /usr/local/lib/ruby/2.7.0/rubygems.rb
   32 /usr/local/lib/ruby/2.7.0/rubygems/path_support.rb
   33 /usr/local/lib/ruby/2.7.0/did_you_mean/version.rb
   34 /usr/local/lib/ruby/2.7.0/did_you_mean/core_ext/name_error.rb
   35 /usr/local/lib/ruby/2.7.0/did_you_mean/levenshtein.rb
   36 /usr/local/lib/ruby/2.7.0/did_you_mean/jaro_winkler.rb
   37 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checker.rb
   38 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/name_error_checkers/class_name_checker.rb
   39 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/name_error_checkers/variable_name_checker.rb
   40 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/name_error_checkers.rb
   41 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/method_name_checker.rb
   42 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/key_error_checker.rb
   43 /usr/local/lib/ruby/2.7.0/did_you_mean/spell_checkers/null_checker.rb
   44 /usr/local/lib/ruby/2.7.0/did_you_mean/formatters/plain_formatter.rb
   45 /usr/local/lib/ruby/2.7.0/did_you_mean/tree_spell_checker.rb
   46 /usr/local/lib/ruby/2.7.0/did_you_mean.rb
   47 /usr/local/lib/ruby/2.7.0/tsort.rb
   48 /usr/local/lib/ruby/2.7.0/rubygems/request_set/gem_dependency_api.rb
   49 /usr/local/lib/ruby/2.7.0/rubygems/request_set/lockfile/parser.rb
   50 /usr/local/lib/ruby/2.7.0/rubygems/request_set/lockfile/tokenizer.rb
   51 /usr/local/lib/ruby/2.7.0/rubygems/request_set/lockfile.rb
   52 /usr/local/lib/ruby/2.7.0/rubygems/request_set.rb
   53 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/gem_metadata.rb
   54 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/errors.rb
   55 /usr/local/lib/ruby/2.7.0/set.rb
   56 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/action.rb
   57 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/add_edge_no_circular.rb
   58 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/add_vertex.rb
   59 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/delete_edge.rb
   60 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/detach_vertex_named.rb
   61 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/set_payload.rb
   62 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/tag.rb
   63 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/log.rb
   64 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph/vertex.rb
   65 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/dependency_graph.rb
   66 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/state.rb
   67 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/modules/specification_provider.rb
   68 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/delegates/resolution_state.rb
   69 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/delegates/specification_provider.rb
   70 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/resolution.rb
   71 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/resolver.rb
   72 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo/modules/ui.rb
   73 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo/lib/molinillo.rb
   74 /usr/local/lib/ruby/2.7.0/rubygems/resolver/molinillo.rb
   75 /usr/local/lib/ruby/2.7.0/rubygems/resolver/activation_request.rb
   76 /usr/local/lib/ruby/2.7.0/rubygems/resolver/conflict.rb
   77 /usr/local/lib/ruby/2.7.0/rubygems/resolver/dependency_request.rb
   78 /usr/local/lib/ruby/2.7.0/rubygems/resolver/requirement_list.rb
   79 /usr/local/lib/ruby/2.7.0/rubygems/resolver/stats.rb
   80 /usr/local/lib/ruby/2.7.0/rubygems/resolver/set.rb
   81 /usr/local/lib/ruby/2.7.0/rubygems/resolver/api_set.rb
   82 /usr/local/lib/ruby/2.7.0/rubygems/resolver/composed_set.rb
   83 /usr/local/lib/ruby/2.7.0/rubygems/resolver/best_set.rb
   84 /usr/local/lib/ruby/2.7.0/rubygems/resolver/current_set.rb
   85 /usr/local/lib/ruby/2.7.0/rubygems/resolver/git_set.rb
   86 /usr/local/lib/ruby/2.7.0/rubygems/resolver/index_set.rb
   87 /usr/local/lib/ruby/2.7.0/rubygems/resolver/installer_set.rb
   88 /usr/local/lib/ruby/2.7.0/rubygems/resolver/lock_set.rb
   89 /usr/local/lib/ruby/2.7.0/rubygems/resolver/vendor_set.rb
   90 /usr/local/lib/ruby/2.7.0/rubygems/resolver/source_set.rb
   91 /usr/local/lib/ruby/2.7.0/rubygems/resolver/specification.rb
   92 /usr/local/lib/ruby/2.7.0/rubygems/resolver/spec_specification.rb
   93 /usr/local/lib/ruby/2.7.0/rubygems/resolver/api_specification.rb
   94 /usr/local/lib/ruby/2.7.0/rubygems/resolver/git_specification.rb
   95 /usr/local/lib/ruby/2.7.0/rubygems/resolver/index_specification.rb
   96 /usr/local/lib/ruby/2.7.0/rubygems/resolver/installed_specification.rb
   97 /usr/local/lib/ruby/2.7.0/rubygems/resolver/local_specification.rb
   98 /usr/local/lib/ruby/2.7.0/rubygems/resolver/lock_specification.rb
   99 /usr/local/lib/ruby/2.7.0/rubygems/resolver/vendor_specification.rb
  100 /usr/local/lib/ruby/2.7.0/rubygems/resolver.rb
  101 /usr/local/lib/ruby/2.7.0/uri/version.rb
  102 /usr/local/lib/ruby/2.7.0/uri/rfc2396_parser.rb
  103 /usr/local/lib/ruby/2.7.0/uri/rfc3986_parser.rb
  104 /usr/local/lib/ruby/2.7.0/uri/common.rb
  105 /usr/local/lib/ruby/2.7.0/uri/generic.rb
  106 /usr/local/lib/ruby/2.7.0/uri/file.rb
  107 /usr/local/lib/ruby/2.7.0/uri/ftp.rb
  108 /usr/local/lib/ruby/2.7.0/uri/http.rb
  109 /usr/local/lib/ruby/2.7.0/uri/https.rb
  110 /usr/local/lib/ruby/2.7.0/uri/ldap.rb
  111 /usr/local/lib/ruby/2.7.0/uri/ldaps.rb
  112 /usr/local/lib/ruby/2.7.0/uri/mailto.rb
  113 /usr/local/lib/ruby/2.7.0/uri.rb
  114 /usr/local/lib/ruby/2.7.0/rubygems/source/git.rb
  115 /usr/local/lib/ruby/2.7.0/rubygems/source/installed.rb
  116 /usr/local/lib/ruby/2.7.0/rubygems/source/specific_file.rb
  117 /usr/local/lib/ruby/2.7.0/rubygems/source/local.rb
  118 /usr/local/lib/ruby/2.7.0/rubygems/source/lock.rb
  119 /usr/local/lib/ruby/2.7.0/rubygems/source/vendor.rb
  120 /usr/local/lib/ruby/2.7.0/rubygems/source.rb
  121 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/fileutils/lib/fileutils.rb
  122 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendored_fileutils.rb
  123 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
  124 /usr/local/lib/ruby/2.7.0/pathname.rb
  125 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/errors.rb
  126 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/environment_preserver.rb
  127 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/plugin/api.rb
  128 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/plugin.rb
  129 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/gem_helpers.rb
  130 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/match_platform.rb
  131 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/rubygems_ext.rb
  132 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/rubygems_integration.rb
  133 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/version.rb
  134 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/constants.rb
  135 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/current_ruby.rb
  136 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/build_metadata.rb
  137 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler.rb
  138 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/command.rb
  139 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/core_ext/hash_with_indifferent_access.rb
  140 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/error.rb
  141 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/invocation.rb
  142 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/nested_context.rb
  143 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/parser/argument.rb
  144 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/parser/arguments.rb
  145 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/parser/option.rb
  146 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/parser/options.rb
  147 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/parser.rb
  148 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/shell.rb
  149 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/line_editor/basic.rb
  150 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/line_editor/readline.rb
  151 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/line_editor.rb
  152 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/util.rb
  153 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/base.rb
  154 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor.rb
  155 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendored_thor.rb
  156 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/friendly_errors.rb
  157 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/common.rb
  158 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/settings.rb
  159 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/feature_flag.rb
  160 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/shared_helpers.rb
  161 /usr/local/lib/ruby/2.7.0/rubygems/ext/builder.rb
  162 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/yaml_serializer.rb
  163 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/config.rb
  164 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/plugin.rb
  165 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli.rb
  166 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/shell/basic.rb
  167 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/thor/lib/thor/shell/color.rb
  168 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/ui.rb
  169 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/ui/shell.rb
  170 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/ui/rg_proxy.rb
  171 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/cli/exec.rb
  172 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source.rb
  173 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source/path.rb
  174 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source/git.rb
  175 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source/rubygems.rb
  176 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/lockfile_parser.rb
  177 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/definition.rb
  178 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/dependency.rb
  179 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/ruby_dsl.rb
  180 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/dsl.rb
  181 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source_list.rb
  182 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source/metadata.rb
  183 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/version.rb
  184 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/rfc2396_parser.rb
  185 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/rfc3986_parser.rb
  186 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/common.rb
  187 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/generic.rb
  188 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/file.rb
  189 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/ftp.rb
  190 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/http.rb
  191 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/https.rb
  192 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/ldap.rb
  193 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/ldaps.rb
  194 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri/mailto.rb
  195 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendor/uri/lib/uri.rb
  196 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/vendored_uri.rb
  197 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/lazy_specification.rb
  198 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/index.rb
  199 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/spec_set.rb
  200 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/runtime.rb
  201 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/source/gemspec.rb
  202 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/dep_proxy.rb
  203 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/remote_specification.rb
  204 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/stub_specification.rb
  205 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/endpoint_specification.rb
  206 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/ruby_version.rb
  207 /usr/local/bundle/gems/bundler-2.2.16/lib/bundler/setup.rb
  208 /usr/local/lib/ruby/2.7.0/forwardable/impl.rb
  209 /usr/local/lib/ruby/2.7.0/forwardable/version.rb
  210 /usr/local/lib/ruby/2.7.0/forwardable.rb
  211 /usr/local/lib/ruby/2.7.0/fileutils.rb
  212 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
  213 /usr/local/lib/ruby/2.7.0/date.rb
  214 /usr/local/lib/ruby/2.7.0/time.rb
  215 /usr/local/lib/ruby/2.7.0/English.rb
  216 /usr/local/lib/ruby/2.7.0/logger/version.rb
  217 /usr/local/lib/ruby/2.7.0/logger/formatter.rb
  218 /usr/local/lib/ruby/2.7.0/logger/period.rb
  219 /usr/local/lib/ruby/2.7.0/logger/log_device.rb
  220 /usr/local/lib/ruby/2.7.0/logger/severity.rb
  221 /usr/local/lib/ruby/2.7.0/logger/errors.rb
  222 /usr/local/lib/ruby/2.7.0/logger.rb
  223 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
  224 /usr/local/lib/ruby/2.7.0/csv/fields_converter.rb
  225 /usr/local/lib/ruby/2.7.0/csv/match_p.rb
  226 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
  227 /usr/local/lib/ruby/2.7.0/csv/delete_suffix.rb
  228 /usr/local/lib/ruby/2.7.0/csv/row.rb
  229 /usr/local/lib/ruby/2.7.0/csv/table.rb
  230 /usr/local/lib/ruby/2.7.0/csv/parser.rb
  231 /usr/local/lib/ruby/2.7.0/csv/writer.rb
  232 /usr/local/lib/ruby/2.7.0/csv/version.rb
  233 /usr/local/lib/ruby/2.7.0/csv/core_ext/array.rb
  234 /usr/local/lib/ruby/2.7.0/csv/core_ext/string.rb
  235 /usr/local/lib/ruby/2.7.0/csv.rb
  236 /usr/local/lib/ruby/2.7.0/json/version.rb
  237 /usr/local/lib/ruby/2.7.0/ostruct/version.rb
  238 /usr/local/lib/ruby/2.7.0/ostruct.rb
  239 /usr/local/lib/ruby/2.7.0/json/generic_object.rb
  240 /usr/local/lib/ruby/2.7.0/json/common.rb
  241 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
  242 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
  243 /usr/local/lib/ruby/2.7.0/json/ext.rb
  244 /usr/local/lib/ruby/2.7.0/json.rb
  245 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/pathutil-0.16.2/lib/pathutil/helpers.rb
  246 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/forwardable-extended-2.6.0/lib/forwardable/extended/version.rb
  247 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/forwardable-extended-2.6.0/lib/forwardable/extended.rb
  248 /usr/local/lib/ruby/2.7.0/find.rb
  249 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/pathutil-0.16.2/lib/pathutil.rb
  250 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable/version.rb
  251 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable/idna/pure.rb
  252 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable/idna.rb
  253 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix/domain.rb
  254 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix/version.rb
  255 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix/errors.rb
  256 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix/rule.rb
  257 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix/list.rb
  258 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/public_suffix-4.0.6/lib/public_suffix.rb
  259 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable/uri.rb
  260 /usr/local/lib/ruby/2.7.0/psych/versions.rb
  261 /usr/local/lib/ruby/2.7.0/psych/exception.rb
  262 /usr/local/lib/ruby/2.7.0/psych/syntax_error.rb
  263 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
  264 /usr/local/lib/ruby/2.7.0/psych/omap.rb
  265 /usr/local/lib/ruby/2.7.0/psych/set.rb
  266 /usr/local/lib/ruby/2.7.0/psych/class_loader.rb
  267 /usr/local/lib/ruby/2.7.0/psych/scalar_scanner.rb
  268 /usr/local/lib/ruby/2.7.0/psych/nodes/node.rb
  269 /usr/local/lib/ruby/2.7.0/psych/nodes/stream.rb
  270 /usr/local/lib/ruby/2.7.0/psych/nodes/document.rb
  271 /usr/local/lib/ruby/2.7.0/psych/nodes/sequence.rb
  272 /usr/local/lib/ruby/2.7.0/psych/nodes/scalar.rb
  273 /usr/local/lib/ruby/2.7.0/psych/nodes/mapping.rb
  274 /usr/local/lib/ruby/2.7.0/psych/nodes/alias.rb
  275 /usr/local/lib/ruby/2.7.0/psych/nodes.rb
  276 /usr/local/lib/ruby/2.7.0/psych/streaming.rb
  277 /usr/local/lib/ruby/2.7.0/psych/visitors/visitor.rb
  278 /usr/local/lib/ruby/2.7.0/psych/visitors/to_ruby.rb
  279 /usr/local/lib/ruby/2.7.0/psych/visitors/emitter.rb
  280 /usr/local/lib/ruby/2.7.0/psych/handler.rb
  281 /usr/local/lib/ruby/2.7.0/psych/tree_builder.rb
  282 /usr/local/lib/ruby/2.7.0/psych/visitors/yaml_tree.rb
  283 /usr/local/lib/ruby/2.7.0/psych/json/ruby_events.rb
  284 /usr/local/lib/ruby/2.7.0/psych/visitors/json_tree.rb
  285 /usr/local/lib/ruby/2.7.0/psych/visitors/depth_first.rb
  286 /usr/local/lib/ruby/2.7.0/psych/visitors.rb
  287 /usr/local/lib/ruby/2.7.0/psych/parser.rb
  288 /usr/local/lib/ruby/2.7.0/psych/coder.rb
  289 /usr/local/lib/ruby/2.7.0/psych/core_ext.rb
  290 /usr/local/lib/ruby/2.7.0/psych/stream.rb
  291 /usr/local/lib/ruby/2.7.0/psych/json/yaml_events.rb
  292 /usr/local/lib/ruby/2.7.0/psych/json/tree_builder.rb
  293 /usr/local/lib/ruby/2.7.0/psych/json/stream.rb
  294 /usr/local/lib/ruby/2.7.0/psych/handlers/document_stream.rb
  295 /usr/local/lib/ruby/2.7.0/psych.rb
  296 /usr/local/lib/ruby/2.7.0/yaml.rb
  297 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/libyaml_checker.rb
  298 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/deep.rb
  299 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/parse/hexadecimal.rb
  300 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/parse/sexagesimal.rb
  301 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/parse/date.rb
  302 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/transformation_map.rb
  303 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_boolean.rb
  304 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_date.rb
  305 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_float.rb
  306 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_integer.rb
  307 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_nil.rb
  308 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform/to_symbol.rb
  309 /usr/local/lib/ruby/2.7.0/base64.rb
  310 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform.rb
  311 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/resolver.rb
  312 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/psych_handler.rb
  313 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/psych_resolver.rb
  314 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/safe_to_ruby_visitor.rb
  315 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/safe_yaml-1.0.5/lib/safe_yaml/load.rb
  316 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/version.rb
  317 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/parse_tree_visitor.rb
  318 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/lexer.rb
  319 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/parser.rb
  320 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/i18n.rb
  321 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/drop.rb
  322 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tablerowloop_drop.rb
  323 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/forloop_drop.rb
  324 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/extensions.rb
  325 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/errors.rb
  326 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/interrupts.rb
  327 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/strainer.rb
  328 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/expression.rb
  329 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/context.rb
  330 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/parser_switching.rb
  331 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tag.rb
  332 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block.rb
  333 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/block_body.rb
  334 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/document.rb
  335 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/variable.rb
  336 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/variable_lookup.rb
  337 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/range_lookup.rb
  338 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/file_system.rb
  339 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/resource_limits.rb
  340 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/template.rb
  341 /usr/local/lib/ruby/2.7.0/cgi/core.rb
  342 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
  343 /usr/local/lib/ruby/2.7.0/cgi/util.rb
  344 /usr/local/lib/ruby/2.7.0/cgi/cookie.rb
  345 /usr/local/lib/ruby/2.7.0/cgi.rb
  346 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
  347 /usr/local/lib/ruby/2.7.0/bigdecimal.rb
  348 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/standardfilters.rb
  349 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/condition.rb
  350 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/utils.rb
  351 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tokenizer.rb
  352 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/parse_context.rb
  353 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/assign.rb
  354 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/break.rb
  355 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/capture.rb
  356 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/case.rb
  357 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/comment.rb
  358 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/continue.rb
  359 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/cycle.rb
  360 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/decrement.rb
  361 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/for.rb
  362 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/if.rb
  363 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/ifchanged.rb
  364 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/include.rb
  365 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/increment.rb
  366 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/raw.rb
  367 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/table_row.rb
  368 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid/tags/unless.rb
  369 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/liquid-4.0.3/lib/liquid.rb
  370 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/version.rb
  371 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/element.rb
  372 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/error.rb
  373 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser.rb
  374 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/utils.rb
  375 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/utils/configurable.rb
  376 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/converter.rb
  377 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/options.rb
  378 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/document.rb
  379 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown.rb
  380 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/colorator-1.1.0/lib/colorator/core_ext.rb
  381 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/colorator-1.1.0/lib/colorator.rb
  382 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/constants.rb
  383 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/utility/engine.rb
  384 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/abstract_object.rb
  385 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/utility/native_extension_loader.rb
  386 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/mri_object.rb
  387 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/jruby_object.rb
  388 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/rbx_object.rb
  389 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/truffleruby_object.rb
  390 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/object.rb
  391 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/volatile.rb
  392 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/abstract_lockable_object.rb
  393 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/mutex_lockable_object.rb
  394 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/jruby_lockable_object.rb
  395 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/rbx_lockable_object.rb
  396 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/lockable_object.rb
  397 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/condition.rb
  398 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization/lock.rb
  399 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/synchronization.rb
  400 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/collection/map/non_concurrent_map_backend.rb
  401 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/collection/map/mri_map_backend.rb
  402 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/map.rb
  403 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/thread_safe/util.rb
  404 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/concurrent-ruby-1.1.8/lib/concurrent-ruby/concurrent/hash.rb
  405 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/i18n-1.8.10/lib/i18n/version.rb
  406 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/i18n-1.8.10/lib/i18n/exceptions.rb
  407 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/i18n-1.8.10/lib/i18n/interpolate/ruby.rb
  408 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/i18n-1.8.10/lib/i18n.rb
  409 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/plugin.rb
  410 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/converter.rb
  411 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/generator.rb
  412 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/command.rb
  413 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_extensions.rb
  414 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/filters/date_filters.rb
  415 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/filters/grouping_filters.rb
  416 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/filters/url_filters.rb
  417 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/filters.rb
  418 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/external.rb
  419 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/log_adapter.rb
  420 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/stevenson.rb
  421 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/drop.rb
  422 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/document_drop.rb
  423 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/build.rb
  424 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/clean.rb
  425 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/doctor.rb
  426 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/help.rb
  427 /usr/local/lib/ruby/2.7.0/erb.rb
  428 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/new.rb
  429 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/new_theme.rb
  430 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/commands/serve.rb
  431 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/converters/identity.rb
  432 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/converters/markdown.rb
  433 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/base.rb
  434 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/blank_line.rb
  435 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/eob.rb
  436 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/extensions.rb
  437 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/horizontal_rule.rb
  438 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/list.rb
  439 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/parseexception.rb
  440 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/undefinednamespaceexception.rb
  441 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/encoding.rb
  442 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/source.rb
  443 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/parsers/baseparser.rb
  444 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/utils/entities.rb
  445 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/html.rb
  446 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/html.rb
  447 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/paragraph.rb
  448 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/block_boundary.rb
  449 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/rexml-3.2.5/lib/rexml/xmltokens.rb
  450 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/header.rb
  451 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/blockquote.rb
  452 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/table.rb
  453 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/codeblock.rb
  454 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/escaped_chars.rb
  455 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/link.rb
  456 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/footnote.rb
  457 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/html_entity.rb
  458 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/line_break.rb
  459 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/typographic_symbol.rb
  460 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/autolink.rb
  461 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/codespan.rb
  462 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/emphasis.rb
  463 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/smart_quotes.rb
  464 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/math.rb
  465 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown/abbreviation.rb
  466 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/parser/kramdown.rb
  467 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/converters/smartypants.rb
  468 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/converters/markdown/kramdown_parser.rb
  469 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/collection_drop.rb
  470 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/excerpt_drop.rb
  471 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/jekyll_drop.rb
  472 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/site_drop.rb
  473 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/static_file_drop.rb
  474 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/unified_payload_drop.rb
  475 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/drops/url_drop.rb
  476 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/tags/highlight.rb
  477 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/tags/include.rb
  478 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/tags/link.rb
  479 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/tags/post_url.rb
  480 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-sass-converter-2.1.0/lib/jekyll-sass-converter/version.rb
  481 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/version.rb
  482 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
  483 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/platform.rb
  484 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/data_converter.rb
  485 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/types.rb
  486 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/library.rb
  487 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/errno.rb
  488 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/abstract_memory.rb
  489 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/pointer.rb
  490 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/memorypointer.rb
  491 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/struct_layout.rb
  492 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/struct_layout_builder.rb
  493 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/struct_by_reference.rb
  494 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/struct.rb
  495 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/union.rb
  496 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/managedstruct.rb
  497 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/callback.rb
  498 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/io.rb
  499 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/autopointer.rb
  500 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/variadic.rb
  501 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/enum.rb
  502 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/version.rb
  503 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi/ffi.rb
  504 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi.rb
  505 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/sass_value.rb
  506 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/sass_input_style.rb
  507 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/sass_output_style.rb
  508 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/string_list.rb
  509 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/native_context_api.rb
  510 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/native_functions_api.rb
  511 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native/sass2scss_api.rb
  512 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/native.rb
  513 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/import_handler.rb
  514 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/importer.rb
  515 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/util.rb
  516 /usr/local/lib/ruby/2.7.0/delegate.rb
  517 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/util/normalized_map.rb
  518 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script.rb
  519 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value.rb
  520 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/bool.rb
  521 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/number.rb
  522 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/color.rb
  523 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/string.rb
  524 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/list.rb
  525 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value/map.rb
  526 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/functions.rb
  527 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion.rb
  528 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/base.rb
  529 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/string.rb
  530 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/number.rb
  531 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/color.rb
  532 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/map.rb
  533 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/list.rb
  534 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/script/value_conversion/bool.rb
  535 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/functions_handler.rb
  536 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/dependency.rb
  537 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/error.rb
  538 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/engine.rb
  539 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/sass_2_scss.rb
  540 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc.rb
  541 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/utils.rb
  542 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/convertible.rb
  543 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/page.rb
  544 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-sass-converter-2.1.0/lib/jekyll/source_map_page.rb
  545 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/hooks.rb
  546 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-sass-converter-2.1.0/lib/jekyll/converters/scss.rb
  547 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-sass-converter-2.1.0/lib/jekyll/converters/sass.rb
  548 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-sass-converter-2.1.0/lib/jekyll-sass-converter.rb
  549 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll.rb
  550 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/version.rb
  551 /usr/local/lib/ruby/2.7.0/optparse.rb
  552 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary.rb
  553 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/plugin_manager.rb
  554 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/objective_elements-1.1.2/lib/objective_elements/single_tag.rb
  555 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/objective_elements-1.1.2/lib/objective_elements/double_tag.rb
  556 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/objective_elements-1.1.2/lib/objective_elements/html_attributes.rb
  557 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/objective_elements-1.1.2/lib/objective_elements/shelf_tag.rb
  558 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/objective_elements-1.1.2/lib/objective_elements.rb
  559 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/cache.rb
  560 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/image_file.rb
  561 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/gobject.rb
  562 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/gvalue.rb
  563 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/object.rb
  564 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/operation.rb
  565 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/image.rb
  566 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/interpolate.rb
  567 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/region.rb
  568 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/version.rb
  569 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/connection.rb
  570 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/source.rb
  571 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/sourcecustom.rb
  572 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/target.rb
  573 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips/targetcustom.rb
  574 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/vips.rb
  575 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ruby-vips-2.0.17/lib/ruby-vips.rb
  576 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/generated_image.rb
  577 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable/template.rb
  578 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/addressable-2.7.0/lib/addressable.rb
  579 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/img_uri.rb
  580 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images/source_image.rb
  581 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/images.rb
  582 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/parents/conditional_instruction.rb
  583 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/parents/env_instruction.rb
  584 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/children/config.rb
  585 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/children/context.rb
  586 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/children/params.rb
  587 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/children/parsers.rb
  588 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/type.rb
  589 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/cache.rb
  590 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/container.rb
  591 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-data-3.2021.0225/lib/mime/types/data.rb
  592 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/loader.rb
  593 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/logger.rb
  594 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/type/columnar.rb
  595 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/_columnar.rb
  596 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types/registry.rb
  597 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime/types.rb
  598 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mime-types-3.3.1/lib/mime-types.rb
  599 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions/children/preset.rb
  600 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/instructions.rb
  601 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/basic.rb
  602 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/data_attributes.rb
  603 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/auto.rb
  604 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/img.rb
  605 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/picture.rb
  606 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/data_auto.rb
  607 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/data_picture.rb
  608 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/data_img.rb
  609 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/direct_url.rb
  610 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats/naked_srcset.rb
  611 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/output_formats.rb
  612 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/arg_splitter.rb
  613 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/configuration.rb
  614 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/html_attributes.rb
  615 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/preset.rb
  616 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/tag_parser.rb
  617 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers/image_backend.rb
  618 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/parsers.rb
  619 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/router.rb
  620 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/basic.rb
  621 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/pixel_ratio.rb
  622 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets/width.rb
  623 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/srcsets.rb
  624 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/utils.rb
  625 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/defaults/presets.rb
  626 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag/defaults/global.rb
  627 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll_picture_tag-2.0.3/lib/jekyll_picture_tag.rb
  628 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/deprecator.rb
  629 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/command.rb
  630 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/program.rb
  631 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/version.rb
  632 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/mercenary-0.4.0/lib/mercenary/option.rb
  633 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/configuration.rb
  634 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/path_manager.rb
  635 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/site.rb
  636 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
  637 /usr/local/lib/ruby/2.7.0/digest.rb
  638 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/cache.rb
  639 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/reader.rb
  640 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/profiler.rb
  641 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/regenerator.rb
  642 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/file.rb
  643 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer/table.rb
  644 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/liquid_renderer.rb
  645 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/frontmatter_defaults.rb
  646 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
  647 /usr/local/lib/ruby/2.7.0/digest/sha2.rb
  648 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/layout_reader.rb
  649 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/entry_filter.rb
  650 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/layout.rb
  651 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/document.rb
  652 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
  653 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
  654 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/collection.rb
  655 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/post_reader.rb
  656 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/page_reader.rb
  657 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/publisher.rb
  658 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/static_file_reader.rb
  659 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/static_file.rb
  660 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/data_reader.rb
  661 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/collection_reader.rb
  662 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/readers/theme_assets_reader.rb
  663 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/renderer.rb
  664 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/jekyll-4.2.0/lib/jekyll/url.rb
  665 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-parser-gfm-1.1.0/lib/kramdown/parser/gfm/options.rb
  666 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-parser-gfm-1.1.0/lib/kramdown/parser/gfm.rb
  667 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-parser-gfm-1.1.0/lib/kramdown-parser-gfm.rb
  668 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/utils/string_scanner.rb
  669 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/converter/base.rb
  670 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/utils/html.rb
  671 /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/kramdown-2.3.1/lib/kramdown/converter/html.rb
  672 /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so

* Process memory map:

5622c0478000-5622c0479000 r--p 00000000 fe:01 2886071                    /usr/local/bin/ruby
5622c0479000-5622c047a000 r-xp 00001000 fe:01 2886071                    /usr/local/bin/ruby
5622c047a000-5622c047b000 r--p 00002000 fe:01 2886071                    /usr/local/bin/ruby
5622c047b000-5622c047c000 r--p 00002000 fe:01 2886071                    /usr/local/bin/ruby
5622c047c000-5622c047d000 rw-p 00003000 fe:01 2886071                    /usr/local/bin/ruby
5622c05da000-5622c05db000 ---p 00000000 00:00 0                          [heap]
5622c05db000-5622c06c8000 rw-p 00000000 00:00 0                          [heap]
7f8fcf9ed000-7f8fcf9f5000 rw-p 00000000 00:00 0 
7f8fcf9f6000-7f8fcf9fa000 rw-p 00000000 00:00 0 
7f8fe44ae000-7f8fe45e5000 rw-p 00000000 00:00 0 
7f8fe460c000-7f8fe4617000 rw-p 00000000 00:00 0 
7f8fe468c000-7f8fe4787000 rw-p 00000000 00:00 0 
7f8fe4887000-7f8fe48b1000 rw-p 00000000 00:00 0 
7f8fe48b9000-7f8fe48c9000 rw-p 00000000 00:00 0 
7f8fe48d1000-7f8fe48e1000 rw-p 00000000 00:00 0 
7f8fe497d000-7f8fe49b0000 rw-p 00000000 00:00 0 
7f8fe49fe000-7f8fe4a79000 rw-p 00000000 00:00 0 
7f8fe4a79000-7f8fe4a89000 rw-p 00000000 00:00 0 
7f8fe4a89000-7f8fe4a99000 rw-s 00000000 fe:01 3147236                    /root/orcexec.NjClbB (deleted)
7f8fe4a99000-7f8fe4aa9000 r-xs 00000000 fe:01 3147236                    /root/orcexec.NjClbB (deleted)
7f8fe4aaf000-7f8fe4af1000 rw-p 00000000 00:00 0 
7f8fe4af1000-7f8fe4af3000 ---p 00000000 00:00 0 
7f8fe4af3000-7f8fe4daa000 rw-p 00000000 00:00 0 
7f8fe4daa000-7f8fe4dab000 r-xp 00000000 00:00 0 
7f8fe4dab000-7f8fe4db9000 rw-p 00000000 00:00 0 
7f8fe4db9000-7f8fe4dba000 r--p 00000000 fe:01 2887350                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so
7f8fe4dba000-7f8fe4dbb000 r-xp 00001000 fe:01 2887350                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so
7f8fe4dbb000-7f8fe4dbc000 r--p 00002000 fe:01 2887350                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so
7f8fe4dbc000-7f8fe4dbd000 r--p 00002000 fe:01 2887350                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so
7f8fe4dbd000-7f8fe4dbe000 rw-p 00003000 fe:01 2887350                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/md5.so
7f8fe4dbe000-7f8fe4dc7000 rw-p 00000000 00:00 0 
7f8fe4dcb000-7f8fe4ea6000 rw-p 00000000 00:00 0 
7f8fe4ea6000-7f8fe4eaa000 rw-p 00000000 00:00 0 
7f8fe4eaa000-7f8fe4eab000 r--p 00000000 fe:01 2887407                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
7f8fe4eab000-7f8fe4eac000 r-xp 00001000 fe:01 2887407                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
7f8fe4eac000-7f8fe4ead000 r--p 00002000 fe:01 2887407                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
7f8fe4ead000-7f8fe4eae000 r--p 00002000 fe:01 2887407                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
7f8fe4eae000-7f8fe4eaf000 rw-p 00003000 fe:01 2887407                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16be.so
7f8fe4eaf000-7f8fe4ecc000 rw-p 00000000 00:00 0 
7f8fe4ecc000-7f8fe4f41000 r--p 00000000 fe:01 2884177                    /lib/libcrypto.so.1.1
7f8fe4f41000-7f8fe5098000 r-xp 00075000 fe:01 2884177                    /lib/libcrypto.so.1.1
7f8fe5098000-7f8fe511c000 r--p 001cc000 fe:01 2884177                    /lib/libcrypto.so.1.1
7f8fe511c000-7f8fe5147000 r--p 0024f000 fe:01 2884177                    /lib/libcrypto.so.1.1
7f8fe5147000-7f8fe5149000 rw-p 0027a000 fe:01 2884177                    /lib/libcrypto.so.1.1
7f8fe5149000-7f8fe567c000 rw-p 00000000 00:00 0 
7f8fe567c000-7f8fe567d000 r--p 00000000 fe:01 2887408                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
7f8fe567d000-7f8fe567e000 r-xp 00001000 fe:01 2887408                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
7f8fe567e000-7f8fe567f000 r--p 00002000 fe:01 2887408                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
7f8fe567f000-7f8fe5680000 r--p 00002000 fe:01 2887408                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
7f8fe5680000-7f8fe5681000 rw-p 00003000 fe:01 2887408                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/utf_16le.so
7f8fe5681000-7f8fe5968000 rw-p 00000000 00:00 0 
7f8fe5968000-7f8fe5969000 r-xp 00000000 00:00 0 
7f8fe5969000-7f8fe59f8000 rw-p 00000000 00:00 0 
7f8fe59f8000-7f8fe59fc000 r--p 00000000 fe:01 3019884                    /usr/lib/libbsd.so.0.10.0
7f8fe59fc000-7f8fe5a08000 r-xp 00004000 fe:01 3019884                    /usr/lib/libbsd.so.0.10.0
7f8fe5a08000-7f8fe5a0b000 r--p 00010000 fe:01 3019884                    /usr/lib/libbsd.so.0.10.0
7f8fe5a0b000-7f8fe5a0c000 r--p 00012000 fe:01 3019884                    /usr/lib/libbsd.so.0.10.0
7f8fe5a0c000-7f8fe5a0d000 rw-p 00013000 fe:01 3019884                    /usr/lib/libbsd.so.0.10.0
7f8fe5a0d000-7f8fe5a0e000 rw-p 00000000 00:00 0 
7f8fe5a0e000-7f8fe5a0f000 r--p 00000000 fe:01 3016785                    /usr/lib/libbrotlicommon.so.1.0.9
7f8fe5a0f000-7f8fe5a10000 r-xp 00001000 fe:01 3016785                    /usr/lib/libbrotlicommon.so.1.0.9
7f8fe5a10000-7f8fe5a2f000 r--p 00002000 fe:01 3016785                    /usr/lib/libbrotlicommon.so.1.0.9
7f8fe5a2f000-7f8fe5a30000 r--p 00020000 fe:01 3016785                    /usr/lib/libbrotlicommon.so.1.0.9
7f8fe5a30000-7f8fe5a31000 rw-p 00021000 fe:01 3016785                    /usr/lib/libbrotlicommon.so.1.0.9
7f8fe5a31000-7f8fe5a33000 r--p 00000000 fe:01 3020316                    /usr/lib/libgraphite2.so.3.2.1
7f8fe5a33000-7f8fe5a47000 r-xp 00002000 fe:01 3020316                    /usr/lib/libgraphite2.so.3.2.1
7f8fe5a47000-7f8fe5a4d000 r--p 00016000 fe:01 3020316                    /usr/lib/libgraphite2.so.3.2.1
7f8fe5a4d000-7f8fe5a4f000 r--p 0001b000 fe:01 3020316                    /usr/lib/libgraphite2.so.3.2.1
7f8fe5a4f000-7f8fe5a50000 rw-p 0001d000 fe:01 3020316                    /usr/lib/libgraphite2.so.3.2.1
7f8fe5a50000-7f8fe5a52000 r--p 00000000 fe:01 3019886                    /usr/lib/libXdmcp.so.6.0.0
7f8fe5a52000-7f8fe5a54000 r-xp 00002000 fe:01 3019886                    /usr/lib/libXdmcp.so.6.0.0
7f8fe5a54000-7f8fe5a56000 r--p 00004000 fe:01 3019886                    /usr/lib/libXdmcp.so.6.0.0
7f8fe5a56000-7f8fe5a57000 r--p 00005000 fe:01 3019886                    /usr/lib/libXdmcp.so.6.0.0
7f8fe5a57000-7f8fe5a58000 rw-p 00006000 fe:01 3019886                    /usr/lib/libXdmcp.so.6.0.0
7f8fe5a58000-7f8fe5a5a000 rw-p 00000000 00:00 0 
7f8fe5a5a000-7f8fe5a5b000 r--p 00000000 fe:01 3019882                    /usr/lib/libXau.so.6.0.0
7f8fe5a5b000-7f8fe5a5c000 r-xp 00001000 fe:01 3019882                    /usr/lib/libXau.so.6.0.0
7f8fe5a5c000-7f8fe5a5d000 r--p 00002000 fe:01 3019882                    /usr/lib/libXau.so.6.0.0
7f8fe5a5d000-7f8fe5a5e000 r--p 00002000 fe:01 3019882                    /usr/lib/libXau.so.6.0.0
7f8fe5a5e000-7f8fe5a5f000 rw-p 00003000 fe:01 3019882                    /usr/lib/libXau.so.6.0.0
7f8fe5a5f000-7f8fe5a60000 r--p 00000000 fe:01 3016787                    /usr/lib/libbrotlidec.so.1.0.9
7f8fe5a60000-7f8fe5a67000 r-xp 00001000 fe:01 3016787                    /usr/lib/libbrotlidec.so.1.0.9
7f8fe5a67000-7f8fe5a6a000 r--p 00008000 fe:01 3016787                    /usr/lib/libbrotlidec.so.1.0.9
7f8fe5a6a000-7f8fe5a6b000 r--p 0000a000 fe:01 3016787                    /usr/lib/libbrotlidec.so.1.0.9
7f8fe5a6b000-7f8fe5a6c000 rw-p 0000b000 fe:01 3016787                    /usr/lib/libbrotlidec.so.1.0.9
7f8fe5a6c000-7f8fe5a6e000 r--p 00000000 fe:01 3020200                    /usr/lib/libbz2.so.1.0.8
7f8fe5a6e000-7f8fe5a77000 r-xp 00002000 fe:01 3020200                    /usr/lib/libbz2.so.1.0.8
7f8fe5a77000-7f8fe5a79000 r--p 0000b000 fe:01 3020200                    /usr/lib/libbz2.so.1.0.8
7f8fe5a79000-7f8fe5a7a000 r--p 0000c000 fe:01 3020200                    /usr/lib/libbz2.so.1.0.8
7f8fe5a7a000-7f8fe5a7b000 rw-p 0000d000 fe:01 3020200                    /usr/lib/libbz2.so.1.0.8
7f8fe5a7b000-7f8fe5a7d000 r--p 00000000 fe:01 3020206                    /lib/libuuid.so.1.3.0
7f8fe5a7d000-7f8fe5a81000 r-xp 00002000 fe:01 3020206                    /lib/libuuid.so.1.3.0
7f8fe5a81000-7f8fe5a82000 r--p 00006000 fe:01 3020206                    /lib/libuuid.so.1.3.0
7f8fe5a82000-7f8fe5a83000 r--p 00006000 fe:01 3020206                    /lib/libuuid.so.1.3.0
7f8fe5a83000-7f8fe5a84000 rw-p 00007000 fe:01 3020206                    /lib/libuuid.so.1.3.0
7f8fe5a84000-7f8fe5a8d000 r--p 00000000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5a8d000-7f8fe5ab7000 r-xp 00009000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5ab7000-7f8fe5ac6000 r--p 00033000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5ac6000-7f8fe5ac7000 r--p 00042000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5ac7000-7f8fe5acb000 r--p 00042000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5acb000-7f8fe5acc000 rw-p 00046000 fe:01 3020256                    /lib/libblkid.so.1.1.0
7f8fe5acc000-7f8fe5ad5000 r--p 00000000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5ad5000-7f8fe5b36000 r-xp 00009000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5b36000-7f8fe5b6b000 r--p 0006a000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5b6b000-7f8fe5b6c000 r--p 0009f000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5b6c000-7f8fe5b6d000 r--p 0009f000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5b6d000-7f8fe5b6e000 rw-p 000a0000 fe:01 3020322                    /usr/lib/libharfbuzz.so.0.20704.0
7f8fe5b6e000-7f8fe5b70000 r--p 00000000 fe:01 3020314                    /usr/lib/libfribidi.so.0.4.0
7f8fe5b70000-7f8fe5b74000 r-xp 00002000 fe:01 3020314                    /usr/lib/libfribidi.so.0.4.0
7f8fe5b74000-7f8fe5b89000 r--p 00006000 fe:01 3020314                    /usr/lib/libfribidi.so.0.4.0
7f8fe5b89000-7f8fe5b8a000 r--p 0001a000 fe:01 3020314                    /usr/lib/libfribidi.so.0.4.0
7f8fe5b8a000-7f8fe5b8b000 rw-p 0001b000 fe:01 3020314                    /usr/lib/libfribidi.so.0.4.0
7f8fe5b8b000-7f8fe5b92000 r--p 00000000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5b92000-7f8fe5b9b000 r-xp 00007000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5b9b000-7f8fe5b9f000 r--p 00010000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5b9f000-7f8fe5ba0000 r--p 00014000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5ba0000-7f8fe5ba1000 r--p 00014000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5ba1000-7f8fe5ba2000 rw-p 00015000 fe:01 3020328                    /usr/lib/libpangoft2-1.0.so.0.4800.2
7f8fe5ba2000-7f8fe5ba5000 r--p 00000000 fe:01 3020298                    /usr/lib/liblzma.so.5.2.5
7f8fe5ba5000-7f8fe5bb8000 r-xp 00003000 fe:01 3020298                    /usr/lib/liblzma.so.5.2.5
7f8fe5bb8000-7f8fe5bc3000 r--p 00016000 fe:01 3020298                    /usr/lib/liblzma.so.5.2.5
7f8fe5bc3000-7f8fe5bc4000 r--p 00020000 fe:01 3020298                    /usr/lib/liblzma.so.5.2.5
7f8fe5bc4000-7f8fe5bc5000 rw-p 00021000 fe:01 3020298                    /usr/lib/liblzma.so.5.2.5
7f8fe5bc5000-7f8fe5bc9000 r--p 00000000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bc9000-7f8fe5bd2000 r-xp 00004000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bd2000-7f8fe5bd5000 r--p 0000d000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bd5000-7f8fe5bd6000 r--p 00010000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bd6000-7f8fe5bd7000 r--p 00010000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bd7000-7f8fe5bd8000 rw-p 00011000 fe:01 3020196                    /usr/lib/libXext.so.6.4.0
7f8fe5bd8000-7f8fe5bf3000 r--p 00000000 fe:01 3019938                    /usr/lib/libX11.so.6.4.0
7f8fe5bf3000-7f8fe5c62000 r-xp 0001b000 fe:01 3019938                    /usr/lib/libX11.so.6.4.0
7f8fe5c62000-7f8fe5cf3000 r--p 0008a000 fe:01 3019938                    /usr/lib/libX11.so.6.4.0
7f8fe5cf3000-7f8fe5cf6000 r--p 0011a000 fe:01 3019938                    /usr/lib/libX11.so.6.4.0
7f8fe5cf6000-7f8fe5cfa000 rw-p 0011d000 fe:01 3019938                    /usr/lib/libX11.so.6.4.0
7f8fe5cfa000-7f8fe5cfc000 r--p 00000000 fe:01 3020198                    /usr/lib/libXrender.so.1.3.0
7f8fe5cfc000-7f8fe5d02000 r-xp 00002000 fe:01 3020198                    /usr/lib/libXrender.so.1.3.0
7f8fe5d02000-7f8fe5d04000 r--p 00008000 fe:01 3020198                    /usr/lib/libXrender.so.1.3.0
7f8fe5d04000-7f8fe5d05000 r--p 00009000 fe:01 3020198                    /usr/lib/libXrender.so.1.3.0
7f8fe5d05000-7f8fe5d06000 rw-p 0000a000 fe:01 3020198                    /usr/lib/libXrender.so.1.3.0
7f8fe5d06000-7f8fe5d0b000 r--p 00000000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d0b000-7f8fe5d10000 r-xp 00005000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d10000-7f8fe5d12000 r--p 0000a000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d12000-7f8fe5d13000 r--p 0000c000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d13000-7f8fe5d14000 r--p 0000c000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d14000-7f8fe5d15000 rw-p 0000d000 fe:01 3019906                    /usr/lib/libxcb-render.so.0.0.0
7f8fe5d15000-7f8fe5d20000 r--p 00000000 fe:01 3019934                    /usr/lib/libxcb.so.1.1.0
7f8fe5d20000-7f8fe5d31000 r-xp 0000b000 fe:01 3019934                    /usr/lib/libxcb.so.1.1.0
7f8fe5d31000-7f8fe5d3a000 r--p 0001c000 fe:01 3019934                    /usr/lib/libxcb.so.1.1.0
7f8fe5d3a000-7f8fe5d3b000 r--p 00024000 fe:01 3019934                    /usr/lib/libxcb.so.1.1.0
7f8fe5d3b000-7f8fe5d3c000 rw-p 00025000 fe:01 3019934                    /usr/lib/libxcb.so.1.1.0
7f8fe5d3c000-7f8fe5d3d000 r--p 00000000 fe:01 3019914                    /usr/lib/libxcb-shm.so.0.0.0
7f8fe5d3d000-7f8fe5d3e000 r-xp 00001000 fe:01 3019914                    /usr/lib/libxcb-shm.so.0.0.0
7f8fe5d3e000-7f8fe5d3f000 r--p 00002000 fe:01 3019914                    /usr/lib/libxcb-shm.so.0.0.0
7f8fe5d3f000-7f8fe5d40000 r--p 00002000 fe:01 3019914                    /usr/lib/libxcb-shm.so.0.0.0
7f8fe5d40000-7f8fe5d41000 rw-p 00003000 fe:01 3019914                    /usr/lib/libxcb-shm.so.0.0.0
7f8fe5d41000-7f8fe5d4e000 r--p 00000000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5d4e000-7f8fe5db6000 r-xp 0000d000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5db6000-7f8fe5dec000 r--p 00075000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5dec000-7f8fe5ded000 r--p 000ab000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5ded000-7f8fe5df4000 r--p 000ab000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5df4000-7f8fe5df5000 rw-p 000b2000 fe:01 3020204                    /usr/lib/libfreetype.so.6.17.4
7f8fe5df5000-7f8fe5dfc000 r--p 00000000 fe:01 3020240                    /usr/lib/libfontconfig.so.1.12.0
7f8fe5dfc000-7f8fe5e18000 r-xp 00007000 fe:01 3020240                    /usr/lib/libfontconfig.so.1.12.0
7f8fe5e18000-7f8fe5e2f000 r--p 00023000 fe:01 3020240                    /usr/lib/libfontconfig.so.1.12.0
7f8fe5e2f000-7f8fe5e31000 r--p 00039000 fe:01 3020240                    /usr/lib/libfontconfig.so.1.12.0
7f8fe5e31000-7f8fe5e32000 rw-p 0003b000 fe:01 3020240                    /usr/lib/libfontconfig.so.1.12.0
7f8fe5e32000-7f8fe5e3c000 r--p 00000000 fe:01 3020242                    /usr/lib/libpixman-1.so.0.40.0
7f8fe5e3c000-7f8fe5ead000 r-xp 0000a000 fe:01 3020242                    /usr/lib/libpixman-1.so.0.40.0
7f8fe5ead000-7f8fe5ebf000 r--p 0007b000 fe:01 3020242                    /usr/lib/libpixman-1.so.0.40.0
7f8fe5ebf000-7f8fe5ec7000 r--p 0008c000 fe:01 3020242                    /usr/lib/libpixman-1.so.0.40.0
7f8fe5ec7000-7f8fe5ec8000 rw-p 00094000 fe:01 3020242                    /usr/lib/libpixman-1.so.0.40.0
7f8fe5ec8000-7f8fe5ed3000 r--p 00000000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5ed3000-7f8fe5f04000 r-xp 0000b000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5f04000-7f8fe5f15000 r--p 0003c000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5f15000-7f8fe5f16000 r--p 0004d000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5f16000-7f8fe5f18000 r--p 0004d000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5f18000-7f8fe5f19000 rw-p 0004f000 fe:01 3020258                    /lib/libmount.so.1.1.0
7f8fe5f19000-7f8fe5f27000 r--p 00000000 fe:01 3020324                    /usr/lib/libpango-1.0.so.0.4800.2
7f8fe5f27000-7f8fe5f44000 r-xp 0000e000 fe:01 3020324                    /usr/lib/libpango-1.0.so.0.4800.2
7f8fe5f44000-7f8fe5f5b000 r--p 0002b000 fe:01 3020324                    /usr/lib/libpango-1.0.so.0.4800.2
7f8fe5f5b000-7f8fe5f5e000 r--p 00041000 fe:01 3020324                    /usr/lib/libpango-1.0.so.0.4800.2
7f8fe5f5e000-7f8fe5f5f000 rw-p 00044000 fe:01 3020324                    /usr/lib/libpango-1.0.so.0.4800.2
7f8fe5f5f000-7f8fe5f64000 r--p 00000000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f64000-7f8fe5f6a000 r-xp 00005000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f6a000-7f8fe5f6c000 r--p 0000b000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f6c000-7f8fe5f6d000 r--p 0000d000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f6d000-7f8fe5f6e000 r--p 0000d000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f6e000-7f8fe5f6f000 rw-p 0000e000 fe:01 3020326                    /usr/lib/libpangocairo-1.0.so.0.4800.2
7f8fe5f6f000-7f8fe5f9d000 r--p 00000000 fe:01 3020300                    /usr/lib/libxml2.so.2.9.10
7f8fe5f9d000-7f8fe604a000 r-xp 0002e000 fe:01 3020300                    /usr/lib/libxml2.so.2.9.10
7f8fe604a000-7f8fe608d000 r--p 000db000 fe:01 3020300                    /usr/lib/libxml2.so.2.9.10
7f8fe608d000-7f8fe6096000 r--p 0011d000 fe:01 3020300                    /usr/lib/libxml2.so.2.9.10
7f8fe6096000-7f8fe6097000 rw-p 00126000 fe:01 3020300                    /usr/lib/libxml2.so.2.9.10
7f8fe6097000-7f8fe6099000 rw-p 00000000 00:00 0 
7f8fe6099000-7f8fe609f000 r--p 00000000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe609f000-7f8fe60b0000 r-xp 00006000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe60b0000-7f8fe60b8000 r--p 00017000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe60b8000-7f8fe60b9000 r--p 0001f000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe60b9000-7f8fe60ba000 r--p 0001f000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe60ba000-7f8fe60bb000 rw-p 00020000 fe:01 3020309                    /usr/lib/libgdk_pixbuf-2.0.so.0.4200.4
7f8fe60bb000-7f8fe60bf000 r--p 00000000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60bf000-7f8fe60c0000 r-xp 00004000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60c0000-7f8fe60c2000 r--p 00005000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60c2000-7f8fe60c3000 r--p 00007000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60c3000-7f8fe60c5000 r--p 00007000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60c5000-7f8fe60c6000 rw-p 00009000 fe:01 3020296                    /usr/lib/libcairo-gobject.so.2.11600.0
7f8fe60c6000-7f8fe60df000 r--p 00000000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe60df000-7f8fe64f5000 r-xp 00019000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe64f5000-7f8fe652a000 r--p 0042f000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe652a000-7f8fe652b000 r--p 00464000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe652b000-7f8fe652d000 r--p 00464000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe652d000-7f8fe652e000 rw-p 00466000 fe:01 3020283                    /usr/lib/libx265.so.192
7f8fe652e000-7f8fe6534000 rw-p 00000000 00:00 0 
7f8fe6534000-7f8fe655f000 r--p 00000000 fe:01 3020282                    /usr/lib/libde265.so.0.0.11
7f8fe655f000-7f8fe65d3000 r-xp 0002b000 fe:01 3020282                    /usr/lib/libde265.so.0.0.11
7f8fe65d3000-7f8fe65f0000 r--p 0009f000 fe:01 3020282                    /usr/lib/libde265.so.0.0.11
7f8fe65f0000-7f8fe65f4000 r--p 000bb000 fe:01 3020282                    /usr/lib/libde265.so.0.0.11
7f8fe65f4000-7f8fe65f5000 rw-p 000bf000 fe:01 3020282                    /usr/lib/libde265.so.0.0.11
7f8fe65f5000-7f8fe65f9000 rw-p 00000000 00:00 0 
7f8fe65f9000-7f8fe660b000 r--p 00000000 fe:01 3020279                    /usr/lib/libaom.so.0
7f8fe660b000-7f8fe68c2000 r-xp 00012000 fe:01 3020279                    /usr/lib/libaom.so.0
7f8fe68c2000-7f8fe69c9000 r--p 002c9000 fe:01 3020279                    /usr/lib/libaom.so.0
7f8fe69c9000-7f8fe69d6000 r--p 003cf000 fe:01 3020279                    /usr/lib/libaom.so.0
7f8fe69d6000-7f8fe69dc000 rw-p 003dc000 fe:01 3020279                    /usr/lib/libaom.so.0
7f8fe69dc000-7f8fe6a18000 rw-p 00000000 00:00 0 
7f8fe6a18000-7f8fe6a28000 r--p 00000000 fe:01 3020248                    /usr/lib/libexif.so.12.3.4
7f8fe6a28000-7f8fe6a36000 r-xp 00010000 fe:01 3020248                    /usr/lib/libexif.so.12.3.4
7f8fe6a36000-7f8fe6a46000 r--p 0001e000 fe:01 3020248                    /usr/lib/libexif.so.12.3.4
7f8fe6a46000-7f8fe6a5a000 r--p 0002d000 fe:01 3020248                    /usr/lib/libexif.so.12.3.4
7f8fe6a5a000-7f8fe6a5b000 rw-p 00041000 fe:01 3020248                    /usr/lib/libexif.so.12.3.4
7f8fe6a5b000-7f8fe6a5d000 r--p 00000000 fe:01 3020335                    /usr/lib/libwebp.so.7.1.0
7f8fe6a5d000-7f8fe6a98000 r-xp 00002000 fe:01 3020335                    /usr/lib/libwebp.so.7.1.0
7f8fe6a98000-7f8fe6aad000 r--p 0003d000 fe:01 3020335                    /usr/lib/libwebp.so.7.1.0
7f8fe6aad000-7f8fe6aae000 r--p 00051000 fe:01 3020335                    /usr/lib/libwebp.so.7.1.0
7f8fe6aae000-7f8fe6aaf000 rw-p 00052000 fe:01 3020335                    /usr/lib/libwebp.so.7.1.0
7f8fe6aaf000-7f8fe6ab1000 rw-p 00000000 00:00 0 
7f8fe6ab1000-7f8fe6ab2000 r--p 00000000 fe:01 3020339                    /usr/lib/libwebpdemux.so.2.0.6
7f8fe6ab2000-7f8fe6ab4000 r-xp 00001000 fe:01 3020339                    /usr/lib/libwebpdemux.so.2.0.6
7f8fe6ab4000-7f8fe6ab5000 r--p 00003000 fe:01 3020339                    /usr/lib/libwebpdemux.so.2.0.6
7f8fe6ab5000-7f8fe6ab6000 r--p 00003000 fe:01 3020339                    /usr/lib/libwebpdemux.so.2.0.6
7f8fe6ab6000-7f8fe6ab7000 rw-p 00004000 fe:01 3020339                    /usr/lib/libwebpdemux.so.2.0.6
7f8fe6ab7000-7f8fe6ab9000 r--p 00000000 fe:01 3020341                    /usr/lib/libwebpmux.so.3.0.5
7f8fe6ab9000-7f8fe6abe000 r-xp 00002000 fe:01 3020341                    /usr/lib/libwebpmux.so.3.0.5
7f8fe6abe000-7f8fe6ac0000 r--p 00007000 fe:01 3020341                    /usr/lib/libwebpmux.so.3.0.5
7f8fe6ac0000-7f8fe6ac1000 r--p 00008000 fe:01 3020341                    /usr/lib/libwebpmux.so.3.0.5
7f8fe6ac1000-7f8fe6ac2000 rw-p 00009000 fe:01 3020341                    /usr/lib/libwebpmux.so.3.0.5
7f8fe6ac2000-7f8fe6ad3000 r--p 00000000 fe:01 3020246                    /usr/lib/libcairo.so.2.11600.0
7f8fe6ad3000-7f8fe6b70000 r-xp 00011000 fe:01 3020246                    /usr/lib/libcairo.so.2.11600.0
7f8fe6b70000-7f8fe6bab000 r--p 000ae000 fe:01 3020246                    /usr/lib/libcairo.so.2.11600.0
7f8fe6bab000-7f8fe6baf000 r--p 000e8000 fe:01 3020246                    /usr/lib/libcairo.so.2.11600.0
7f8fe6baf000-7f8fe6bb0000 rw-p 000ec000 fe:01 3020246                    /usr/lib/libcairo.so.2.11600.0
7f8fe6bb0000-7f8fe6bb1000 rw-p 00000000 00:00 0 
7f8fe6bb1000-7f8fe6be9000 r--p 00000000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6be9000-7f8fe6ccb000 r-xp 00038000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6ccb000-7f8fe6d4d000 r--p 0011a000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6d4d000-7f8fe6d4e000 r--p 0019c000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6d4e000-7f8fe6d57000 r--p 0019c000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6d57000-7f8fe6d58000 rw-p 001a5000 fe:01 3020270                    /usr/lib/libgio-2.0.so.0.6600.8
7f8fe6d58000-7f8fe6d5a000 rw-p 00000000 00:00 0 
7f8fe6d5a000-7f8fe6e6a000 r--p 00000000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe6e6a000-7f8fe73ee000 r-xp 00110000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe73ee000-7f8fe76be000 r--p 00694000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe76be000-7f8fe76bf000 r--p 00964000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe76bf000-7f8fe7788000 r--p 00964000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe7788000-7f8fe7789000 rw-p 00a2d000 fe:01 3020333                    /usr/lib/librsvg-2.so.2.47.0
7f8fe7789000-7f8fe778a000 rw-p 00000000 00:00 0 
7f8fe778a000-7f8fe778c000 r--p 00000000 fe:01 3020254                    /usr/lib/libgif.so.7.2.0
7f8fe778c000-7f8fe7791000 r-xp 00002000 fe:01 3020254                    /usr/lib/libgif.so.7.2.0
7f8fe7791000-7f8fe7793000 r--p 00007000 fe:01 3020254                    /usr/lib/libgif.so.7.2.0
7f8fe7793000-7f8fe7794000 r--p 00008000 fe:01 3020254                    /usr/lib/libgif.so.7.2.0
7f8fe7794000-7f8fe7795000 rw-p 00009000 fe:01 3020254                    /usr/lib/libgif.so.7.2.0
7f8fe7795000-7f8fe77a0000 r--p 00000000 fe:01 3020292                    /usr/lib/liblcms2.so.2.0.10
7f8fe77a0000-7f8fe77cc000 r-xp 0000b000 fe:01 3020292                    /usr/lib/liblcms2.so.2.0.10
7f8fe77cc000-7f8fe77e0000 r--p 00037000 fe:01 3020292                    /usr/lib/liblcms2.so.2.0.10
7f8fe77e0000-7f8fe77e2000 r--p 0004a000 fe:01 3020292                    /usr/lib/liblcms2.so.2.0.10
7f8fe77e2000-7f8fe77e5000 rw-p 0004c000 fe:01 3020292                    /usr/lib/liblcms2.so.2.0.10
7f8fe77e5000-7f8fe77e7000 rw-p 00000000 00:00 0 
7f8fe77e7000-7f8fe77f0000 r--p 00000000 fe:01 3020294                    /usr/lib/liborc-0.4.so.0.32.0
7f8fe77f0000-7f8fe7833000 r-xp 00009000 fe:01 3020294                    /usr/lib/liborc-0.4.so.0.32.0
7f8fe7833000-7f8fe7853000 r--p 0004c000 fe:01 3020294                    /usr/lib/liborc-0.4.so.0.32.0
7f8fe7853000-7f8fe7855000 r--p 0006b000 fe:01 3020294                    /usr/lib/liborc-0.4.so.0.32.0
7f8fe7855000-7f8fe7859000 rw-p 0006d000 fe:01 3020294                    /usr/lib/liborc-0.4.so.0.32.0
7f8fe7859000-7f8fe787c000 r--p 00000000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe787c000-7f8fe79e3000 r-xp 00023000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe79e3000-7f8fe7a0c000 r--p 0018a000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe7a0c000-7f8fe7a0d000 r--p 001b3000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe7a0d000-7f8fe7a1e000 r--p 001b3000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe7a1e000-7f8fe7a1f000 rw-p 001c4000 fe:01 3020250                    /usr/lib/libfftw3.so.3.6.9
7f8fe7a1f000-7f8fe7a23000 r--p 00000000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a23000-7f8fe7a37000 r-xp 00004000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a37000-7f8fe7a3e000 r--p 00018000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a3e000-7f8fe7a3f000 r--p 0001f000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a3f000-7f8fe7a41000 r--p 0001f000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a41000-7f8fe7a42000 rw-p 00021000 fe:01 3016796                    /usr/lib/libexpat.so.1.6.12
7f8fe7a42000-7f8fe7a43000 r--p 00000000 fe:01 3020274                    /usr/lib/libgmodule-2.0.so.0.6600.8
7f8fe7a43000-7f8fe7a44000 r-xp 00001000 fe:01 3020274                    /usr/lib/libgmodule-2.0.so.0.6600.8
7f8fe7a44000-7f8fe7a45000 r--p 00002000 fe:01 3020274                    /usr/lib/libgmodule-2.0.so.0.6600.8
7f8fe7a45000-7f8fe7a46000 r--p 00002000 fe:01 3020274                    /usr/lib/libgmodule-2.0.so.0.6600.8
7f8fe7a46000-7f8fe7a47000 rw-p 00003000 fe:01 3020274                    /usr/lib/libgmodule-2.0.so.0.6600.8
7f8fe7a47000-7f8fe7a4b000 r--p 00000000 fe:01 3020288                    /usr/lib/libjpeg.so.8.2.2
7f8fe7a4b000-7f8fe7a8a000 r-xp 00004000 fe:01 3020288                    /usr/lib/libjpeg.so.8.2.2
7f8fe7a8a000-7f8fe7ac4000 r--p 00043000 fe:01 3020288                    /usr/lib/libjpeg.so.8.2.2
7f8fe7ac4000-7f8fe7ac5000 r--p 0007c000 fe:01 3020288                    /usr/lib/libjpeg.so.8.2.2
7f8fe7ac5000-7f8fe7ac6000 rw-p 0007d000 fe:01 3020288                    /usr/lib/libjpeg.so.8.2.2
7f8fe7ac6000-7f8fe7ace000 r--p 00000000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7ace000-7f8fe7b03000 r-xp 00008000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7b03000-7f8fe7b2f000 r--p 0003d000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7b2f000-7f8fe7b30000 r--p 00069000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7b30000-7f8fe7b34000 r--p 00069000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7b34000-7f8fe7b35000 rw-p 0006d000 fe:01 3020303                    /usr/lib/libtiff.so.5.6.0
7f8fe7b35000-7f8fe7b37000 r--p 00000000 fe:01 3020286                    /usr/lib/libimagequant.so.0
7f8fe7b37000-7f8fe7b41000 r-xp 00002000 fe:01 3020286                    /usr/lib/libimagequant.so.0
7f8fe7b41000-7f8fe7b43000 r--p 0000c000 fe:01 3020286                    /usr/lib/libimagequant.so.0
7f8fe7b43000-7f8fe7b44000 r--p 0000d000 fe:01 3020286                    /usr/lib/libimagequant.so.0
7f8fe7b44000-7f8fe7b45000 rw-p 0000e000 fe:01 3020286                    /usr/lib/libimagequant.so.0
7f8fe7b45000-7f8fe7b4b000 r--p 00000000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b4b000-7f8fe7b68000 r-xp 00006000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b68000-7f8fe7b73000 r--p 00023000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b73000-7f8fe7b74000 r--p 0002e000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b74000-7f8fe7b75000 r--p 0002e000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b75000-7f8fe7b76000 rw-p 0002f000 fe:01 3020202                    /usr/lib/libpng16.so.16.37.0
7f8fe7b76000-7f8fe7b88000 r--p 00000000 fe:01 3020285                    /usr/lib/libheif.so.1.9.1
7f8fe7b88000-7f8fe7bdf000 r-xp 00012000 fe:01 3020285                    /usr/lib/libheif.so.1.9.1
7f8fe7bdf000-7f8fe7bf8000 r--p 00069000 fe:01 3020285                    /usr/lib/libheif.so.1.9.1
7f8fe7bf8000-7f8fe7bfc000 r--p 00081000 fe:01 3020285                    /usr/lib/libheif.so.1.9.1
7f8fe7bfc000-7f8fe7bfd000 rw-p 00085000 fe:01 3020285                    /usr/lib/libheif.so.1.9.1
7f8fe7bfd000-7f8fe7c50000 r--p 00000000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7c50000-7f8fe7d70000 r-xp 00053000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7d70000-7f8fe7dc4000 r--p 00173000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7dc4000-7f8fe7dc5000 r--p 001c7000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7dc5000-7f8fe7dd2000 r--p 001c7000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7dd2000-7f8fe7ecd000 rw-p 001d4000 fe:01 3020345                    /usr/lib/libvips.so.42.12.6
7f8fe7ecd000-7f8fe809f000 rw-p 00000000 00:00 0 
7f8fe809f000-7f8fe80ad000 r--p 00000000 fe:01 3020276                    /usr/lib/libgobject-2.0.so.0.6600.8
7f8fe80ad000-7f8fe80ce000 r-xp 0000e000 fe:01 3020276                    /usr/lib/libgobject-2.0.so.0.6600.8
7f8fe80ce000-7f8fe80e5000 r--p 0002f000 fe:01 3020276                    /usr/lib/libgobject-2.0.so.0.6600.8
7f8fe80e5000-7f8fe80e8000 r--p 00045000 fe:01 3020276                    /usr/lib/libgobject-2.0.so.0.6600.8
7f8fe80e8000-7f8fe80e9000 rw-p 00048000 fe:01 3020276                    /usr/lib/libgobject-2.0.so.0.6600.8
7f8fe80e9000-7f8fe80ea000 rw-p 00000000 00:00 0 
7f8fe80ea000-7f8fe80ec000 r--p 00000000 fe:01 3020260                    /usr/lib/libpcre.so.1.2.12
7f8fe80ec000-7f8fe8128000 r-xp 00002000 fe:01 3020260                    /usr/lib/libpcre.so.1.2.12
7f8fe8128000-7f8fe8144000 r--p 0003e000 fe:01 3020260                    /usr/lib/libpcre.so.1.2.12
7f8fe8144000-7f8fe8145000 r--p 00059000 fe:01 3020260                    /usr/lib/libpcre.so.1.2.12
7f8fe8145000-7f8fe8146000 rw-p 0005a000 fe:01 3020260                    /usr/lib/libpcre.so.1.2.12
7f8fe8146000-7f8fe8161000 r--p 00000000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe8161000-7f8fe81c5000 r-xp 0001b000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe81c5000-7f8fe8249000 r--p 0007f000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe8249000-7f8fe824a000 r--p 00103000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe824a000-7f8fe824b000 r--p 00103000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe824b000-7f8fe824c000 rw-p 00104000 fe:01 3020272                    /usr/lib/libglib-2.0.so.0.6600.8
7f8fe824c000-7f8fe8280000 rw-p 00000000 00:00 0 
7f8fe8280000-7f8fe82ab000 rw-p 00000000 00:00 0 
7f8fe82ab000-7f8fe82ad000 r--p 00000000 fe:01 2886043                    /usr/lib/libintl.so.8.1.7
7f8fe82ad000-7f8fe82b3000 r-xp 00002000 fe:01 2886043                    /usr/lib/libintl.so.8.1.7
7f8fe82b3000-7f8fe82b5000 r--p 00008000 fe:01 2886043                    /usr/lib/libintl.so.8.1.7
7f8fe82b5000-7f8fe82b6000 r--p 00009000 fe:01 2886043                    /usr/lib/libintl.so.8.1.7
7f8fe82b6000-7f8fe82b7000 rw-p 0000a000 fe:01 2886043                    /usr/lib/libintl.so.8.1.7
7f8fe82b7000-7f8fe836c000 rw-p 00000000 00:00 0 
7f8fe836c000-7f8fe836d000 r-xp 00000000 00:00 0 
7f8fe836d000-7f8fe8397000 rw-p 00000000 00:00 0 
7f8fe8397000-7f8fe839a000 r--p 00000000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe839a000-7f8fe83ab000 r-xp 00003000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe83ab000-7f8fe83ae000 r--p 00014000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe83ae000-7f8fe83af000 r--p 00017000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe83af000-7f8fe83b0000 r--p 00017000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe83b0000-7f8fe83b1000 rw-p 00018000 fe:01 2884524                    /usr/lib/libgcc_s.so.1
7f8fe83b1000-7f8fe8468000 r--p 00000000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe8468000-7f8fe84fa000 r-xp 000b7000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe84fa000-7f8fe853f000 r--p 00149000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe853f000-7f8fe8540000 r--p 0018e000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe8540000-7f8fe854f000 r--p 0018e000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe854f000-7f8fe8550000 rw-p 0019d000 fe:01 2884536                    /usr/lib/libstdc++.so.6.0.28
7f8fe8550000-7f8fe8553000 rw-p 00000000 00:00 0 
7f8fe8553000-7f8fe87de000 r--p 00000000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe87de000-7f8fe89ef000 r-xp 0028b000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe89ef000-7f8fe8aa3000 r--p 0049c000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe8aa3000-7f8fe8aa4000 r--p 00550000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe8aa4000-7f8fe8aca000 r--p 00550000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe8aca000-7f8fe8acb000 rw-p 00576000 00:81 4804657                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/sassc-2.4.0/lib/sassc/libsass.so
7f8fe8acb000-7f8fe8b4c000 rw-p 00000000 00:00 0 
7f8fe8b4c000-7f8fe8b4e000 r--p 00000000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b4e000-7f8fe8b53000 r-xp 00002000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b53000-7f8fe8b54000 r--p 00007000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b54000-7f8fe8b55000 r--p 00008000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b55000-7f8fe8b56000 r--p 00008000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b56000-7f8fe8b57000 rw-p 00009000 fe:01 2886035                    /usr/lib/libffi.so.7.1.0
7f8fe8b57000-7f8fe8b5c000 r--p 00000000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b5c000-7f8fe8b76000 r-xp 00005000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b76000-7f8fe8b7e000 r--p 0001f000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b7e000-7f8fe8b7f000 r--p 00027000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b7f000-7f8fe8b80000 r--p 00027000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b80000-7f8fe8b81000 rw-p 00028000 00:81 4802510                    /github/workspace/jekyll-jpt-avif/vendor/bundle/ruby/2.7.0/gems/ffi-1.15.0/lib/ffi_c.so
7f8fe8b81000-7f8fe919d000 rw-p 00000000 00:00 0 
7f8fe919d000-7f8fe919f000 rw-p 00000000 00:00 0 
7f8fe919f000-7f8fe91a1000 r--p 00000000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91a1000-7f8fe91b3000 r-xp 00002000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91b3000-7f8fe91b6000 r--p 00014000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91b6000-7f8fe91b7000 r--p 00017000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91b7000-7f8fe91b8000 r--p 00017000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91b8000-7f8fe91b9000 rw-p 00018000 fe:01 2887341                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/bigdecimal.so
7f8fe91b9000-7f8fe94a9000 rw-p 00000000 00:00 0 
7f8fe94a9000-7f8fe94aa000 rw-p 00000000 00:00 0 
7f8fe94aa000-7f8fe94ab000 r--p 00000000 fe:01 2887353                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
7f8fe94ab000-7f8fe94ac000 r-xp 00001000 fe:01 2887353                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
7f8fe94ac000-7f8fe94ad000 r--p 00002000 fe:01 2887353                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
7f8fe94ad000-7f8fe94ae000 r--p 00002000 fe:01 2887353                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
7f8fe94ae000-7f8fe94af000 rw-p 00003000 fe:01 2887353                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest/sha2.so
7f8fe94af000-7f8fe94d6000 rw-p 00000000 00:00 0 
7f8fe94d6000-7f8fe94e2000 rw-p 00000000 00:00 0 
7f8fe94e2000-7f8fe94e4000 r--p 00000000 fe:01 2887354                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
7f8fe94e4000-7f8fe94e6000 r-xp 00002000 fe:01 2887354                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
7f8fe94e6000-7f8fe94e7000 r--p 00004000 fe:01 2887354                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
7f8fe94e7000-7f8fe94e8000 r--p 00004000 fe:01 2887354                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
7f8fe94e8000-7f8fe94e9000 rw-p 00005000 fe:01 2887354                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/digest.so
7f8fe94e9000-7f8fe96c3000 rw-p 00000000 00:00 0 
7f8fe96c3000-7f8fe96c9000 rw-p 00000000 00:00 0 
7f8fe96c9000-7f8fe96cb000 r--p 00000000 fe:01 2886053                    /usr/lib/libyaml-0.so.2.0.9
7f8fe96cb000-7f8fe96df000 r-xp 00002000 fe:01 2886053                    /usr/lib/libyaml-0.so.2.0.9
7f8fe96df000-7f8fe96e3000 r--p 00016000 fe:01 2886053                    /usr/lib/libyaml-0.so.2.0.9
7f8fe96e3000-7f8fe96e4000 r--p 00019000 fe:01 2886053                    /usr/lib/libyaml-0.so.2.0.9
7f8fe96e4000-7f8fe96e5000 rw-p 0001a000 fe:01 2886053                    /usr/lib/libyaml-0.so.2.0.9
7f8fe96e5000-7f8fe96e7000 r--p 00000000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96e7000-7f8fe96eb000 r-xp 00002000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96eb000-7f8fe96ec000 r--p 00006000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96ec000-7f8fe96ed000 r--p 00007000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96ed000-7f8fe96ee000 r--p 00007000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96ee000-7f8fe96ef000 rw-p 00008000 fe:01 2887436                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/psych.so
7f8fe96ef000-7f8fe9771000 rw-p 00000000 00:00 0 
7f8fe9771000-7f8fe9773000 r--p 00000000 fe:01 2887429                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
7f8fe9773000-7f8fe977a000 r-xp 00002000 fe:01 2887429                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
7f8fe977a000-7f8fe977c000 r--p 00009000 fe:01 2887429                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
7f8fe977c000-7f8fe977d000 r--p 0000a000 fe:01 2887429                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
7f8fe977d000-7f8fe977e000 rw-p 0000b000 fe:01 2887429                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/generator.so
7f8fe977e000-7f8fe9780000 r--p 00000000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9780000-7f8fe9784000 r-xp 00002000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9784000-7f8fe9785000 r--p 00006000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9785000-7f8fe9786000 r--p 00007000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9786000-7f8fe9787000 r--p 00007000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9787000-7f8fe9788000 rw-p 00008000 fe:01 2887430                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/json/ext/parser.so
7f8fe9788000-7f8fe97e7000 rw-p 00000000 00:00 0 
7f8fe97e7000-7f8fe9817000 rw-p 00000000 00:00 0 
7f8fe9817000-7f8fe981a000 r--p 00000000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe981a000-7f8fe984c000 r-xp 00003000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe984c000-7f8fe9854000 r--p 00035000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe9854000-7f8fe9855000 r--p 0003d000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe9855000-7f8fe9856000 r--p 0003d000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe9856000-7f8fe9857000 rw-p 0003e000 fe:01 2887346                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/date_core.so
7f8fe9857000-7f8fe9873000 rw-p 00000000 00:00 0 
7f8fe9873000-7f8fe9875000 rw-p 00000000 00:00 0 
7f8fe9875000-7f8fe9877000 r--p 00000000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe9877000-7f8fe987a000 r-xp 00002000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe987a000-7f8fe987b000 r--p 00005000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe987b000-7f8fe987c000 r--p 00006000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe987c000-7f8fe987d000 r--p 00006000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe987d000-7f8fe987e000 rw-p 00007000 fe:01 2887448                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/strscan.so
7f8fe987e000-7f8fe9fb4000 rw-p 00000000 00:00 0 
7f8fe9fb4000-7f8fe9fb8000 rw-p 00000000 00:00 0 
7f8fe9fb8000-7f8fe9fba000 rw-p 00000000 00:00 0 
7f8fe9fba000-7f8fe9fbc000 r--p 00000000 fe:01 2887435                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
7f8fe9fbc000-7f8fe9fc2000 r-xp 00002000 fe:01 2887435                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
7f8fe9fc2000-7f8fe9fc4000 r--p 00008000 fe:01 2887435                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
7f8fe9fc4000-7f8fe9fc5000 r--p 00009000 fe:01 2887435                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
7f8fe9fc5000-7f8fe9fc6000 rw-p 0000a000 fe:01 2887435                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/pathname.so
7f8fe9fc6000-7f8fea050000 rw-p 00000000 00:00 0 
7f8fea050000-7f8fea054000 rw-p 00000000 00:00 0 
7f8fea054000-7f8fea056000 rw-p 00000000 00:00 0 
7f8fea056000-7f8fea058000 r--p 00000000 fe:01 2887447                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
7f8fea058000-7f8fea05e000 r-xp 00002000 fe:01 2887447                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
7f8fea05e000-7f8fea060000 r--p 00008000 fe:01 2887447                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
7f8fea060000-7f8fea061000 r--p 00009000 fe:01 2887447                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
7f8fea061000-7f8fea062000 rw-p 0000a000 fe:01 2887447                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/stringio.so
7f8fea062000-7f8fea2c3000 rw-p 00000000 00:00 0 
7f8fea2c3000-7f8fea2d1000 rw-p 00000000 00:00 0 
7f8fea2d1000-7f8fea2d2000 r--p 00000000 fe:01 2887431                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
7f8fea2d2000-7f8fea2d3000 r-xp 00001000 fe:01 2887431                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
7f8fea2d3000-7f8fea2d4000 r--p 00002000 fe:01 2887431                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
7f8fea2d4000-7f8fea2d5000 r--p 00002000 fe:01 2887431                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
7f8fea2d5000-7f8fea2d6000 rw-p 00003000 fe:01 2887431                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/monitor.so
7f8fea2d6000-7f8fea5a0000 rw-p 00000000 00:00 0 
7f8fea5a0000-7f8fea5a1000 r--p 00000000 fe:01 2887404                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
7f8fea5a1000-7f8fea5a3000 r-xp 00001000 fe:01 2887404                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
7f8fea5a3000-7f8fea5a4000 r--p 00003000 fe:01 2887404                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
7f8fea5a4000-7f8fea5a5000 r--p 00003000 fe:01 2887404                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
7f8fea5a5000-7f8fea5a6000 rw-p 00004000 fe:01 2887404                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/trans/transdb.so
7f8fea5a6000-7f8fea5ad000 rw-p 00000000 00:00 0 
7f8fea5ad000-7f8fea5ae000 r--p 00000000 fe:01 2887360                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
7f8fea5ae000-7f8fea5af000 r-xp 00001000 fe:01 2887360                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
7f8fea5af000-7f8fea5b0000 r--p 00002000 fe:01 2887360                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
7f8fea5b0000-7f8fea5b1000 r--p 00002000 fe:01 2887360                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
7f8fea5b1000-7f8fea5b2000 rw-p 00003000 fe:01 2887360                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/enc/encdb.so
7f8fea5b2000-7f8fea5cc000 rw-p 00000000 00:00 0 
7f8fea5cc000-7f8fea5cd000 ---p 00000000 00:00 0 
7f8fea5cd000-7f8fea66e000 rw-p 00000000 00:00 0 
7f8fea66e000-7f8fea66f000 ---p 00000000 00:00 0 
7f8fea66f000-7f8fea710000 rw-p 00000000 00:00 0 
7f8fea710000-7f8fea711000 ---p 00000000 00:00 0 
7f8fea711000-7f8fea7b2000 rw-p 00000000 00:00 0 
7f8fea7b2000-7f8fea7b3000 ---p 00000000 00:00 0 
7f8fea7b3000-7f8fea854000 rw-p 00000000 00:00 0 
7f8fea854000-7f8fea855000 ---p 00000000 00:00 0 
7f8fea855000-7f8fea8f6000 rw-p 00000000 00:00 0 
7f8fea8f6000-7f8fea8f7000 ---p 00000000 00:00 0 
7f8fea8f7000-7f8fea998000 rw-p 00000000 00:00 0 
7f8fea998000-7f8fea999000 ---p 00000000 00:00 0 
7f8fea999000-7f8feaa3a000 rw-p 00000000 00:00 0 
7f8feaa3a000-7f8feaa3b000 ---p 00000000 00:00 0 
7f8feaa3b000-7f8feaadc000 rw-p 00000000 00:00 0 
7f8feaadc000-7f8feaadd000 ---p 00000000 00:00 0 
7f8feaadd000-7f8feab7e000 rw-p 00000000 00:00 0 
7f8feab7e000-7f8feab7f000 ---p 00000000 00:00 0 
7f8feab7f000-7f8feac20000 rw-p 00000000 00:00 0 
7f8feac20000-7f8feac21000 ---p 00000000 00:00 0 
7f8feac21000-7f8feacc2000 rw-p 00000000 00:00 0 
7f8feacc2000-7f8feacc3000 ---p 00000000 00:00 0 
7f8feacc3000-7f8fead64000 rw-p 00000000 00:00 0 
7f8fead64000-7f8fead65000 ---p 00000000 00:00 0 
7f8fead65000-7f8feae06000 rw-p 00000000 00:00 0 
7f8feae06000-7f8feae07000 ---p 00000000 00:00 0 
7f8feae07000-7f8feaea8000 rw-p 00000000 00:00 0 
7f8feaea8000-7f8feaea9000 ---p 00000000 00:00 0 
7f8feaea9000-7f8feaf4a000 rw-p 00000000 00:00 0 
7f8feaf4a000-7f8feaf4b000 ---p 00000000 00:00 0 
7f8feaf4b000-7f8feafec000 rw-p 00000000 00:00 0 
7f8feafec000-7f8feafed000 ---p 00000000 00:00 0 
7f8feafed000-7f8feb08e000 rw-p 00000000 00:00 0 
7f8feb08e000-7f8feb08f000 ---p 00000000 00:00 0 
7f8feb08f000-7f8feb130000 rw-p 00000000 00:00 0 
7f8feb130000-7f8feb131000 ---p 00000000 00:00 0 
7f8feb131000-7f8feb1d2000 rw-p 00000000 00:00 0 
7f8feb1d2000-7f8feb1d3000 ---p 00000000 00:00 0 
7f8feb1d3000-7f8feb274000 rw-p 00000000 00:00 0 
7f8feb274000-7f8feb275000 ---p 00000000 00:00 0 
7f8feb275000-7f8feb316000 rw-p 00000000 00:00 0 
7f8feb316000-7f8feb317000 ---p 00000000 00:00 0 
7f8feb317000-7f8feb3b8000 rw-p 00000000 00:00 0 
7f8feb3b8000-7f8feb3b9000 ---p 00000000 00:00 0 
7f8feb3b9000-7f8feb45a000 rw-p 00000000 00:00 0 
7f8feb45a000-7f8feb45b000 ---p 00000000 00:00 0 
7f8feb45b000-7f8feb4fc000 rw-p 00000000 00:00 0 
7f8feb4fc000-7f8feb4fd000 ---p 00000000 00:00 0 
7f8feb4fd000-7f8feb59e000 rw-p 00000000 00:00 0 
7f8feb59e000-7f8feb59f000 ---p 00000000 00:00 0 
7f8feb59f000-7f8feb640000 rw-p 00000000 00:00 0 
7f8feb640000-7f8feb641000 ---p 00000000 00:00 0 
7f8feb641000-7f8feb6e2000 rw-p 00000000 00:00 0 
7f8feb6e2000-7f8feb6e3000 ---p 00000000 00:00 0 
7f8feb6e3000-7f8feb784000 rw-p 00000000 00:00 0 
7f8feb784000-7f8feb785000 ---p 00000000 00:00 0 
7f8feb785000-7f8feb826000 rw-p 00000000 00:00 0 
7f8feb826000-7f8feb827000 ---p 00000000 00:00 0 
7f8feb827000-7f8feb8c8000 rw-p 00000000 00:00 0 
7f8feb8c8000-7f8feb8c9000 ---p 00000000 00:00 0 
7f8feb8c9000-7f8feb96a000 rw-p 00000000 00:00 0 
7f8feb96a000-7f8feb96b000 ---p 00000000 00:00 0 
7f8feb96b000-7f8fedb20000 rw-p 00000000 00:00 0 
7f8fedb20000-7f8fedb29000 rw-p 00000000 00:00 0 
7f8fedb29000-7f8fedb2a000 r--p 00000000 fe:01 2887343                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
7f8fedb2a000-7f8fedb2c000 r-xp 00001000 fe:01 2887343                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
7f8fedb2c000-7f8fedb2d000 r--p 00003000 fe:01 2887343                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
7f8fedb2d000-7f8fedb2e000 r--p 00003000 fe:01 2887343                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
7f8fedb2e000-7f8fedb2f000 rw-p 00004000 fe:01 2887343                    /usr/local/lib/ruby/2.7.0/x86_64-linux-musl/cgi/escape.so
7f8fedb2f000-7f8fedd1a000 rw-p 00000000 00:00 0 
7f8fedd1a000-7f8fedd25000 r--p 00000000 fe:01 2884528                    /usr/lib/libgmp.so.10.4.1
7f8fedd25000-7f8fedd67000 r-xp 0000b000 fe:01 2884528                    /usr/lib/libgmp.so.10.4.1
7f8fedd67000-7f8fedd7d000 r--p 0004d000 fe:01 2884528                    /usr/lib/libgmp.so.10.4.1
7f8fedd7d000-7f8fedd7f000 r--p 00062000 fe:01 2884528                    /usr/lib/libgmp.so.10.4.1
7f8fedd7f000-7f8fedd80000 rw-p 00064000 fe:01 2884528                    /usr/lib/libgmp.so.10.4.1
7f8fedd80000-7f8fedd83000 r--p 00000000 fe:01 2884180                    /lib/libz.so.1.2.11
7f8fedd83000-7f8fedd91000 r-xp 00003000 fe:01 2884180                    /lib/libz.so.1.2.11
7f8fedd91000-7f8fedd98000 r--p 00011000 fe:01 2884180                    /lib/libz.so.1.2.11
7f8fedd98000-7f8fedd99000 r--p 00017000 fe:01 2884180                    /lib/libz.so.1.2.11
7f8fedd99000-7f8fedd9a000 rw-p 00018000 fe:01 2884180                    /lib/libz.so.1.2.11
7f8fedd9a000-7f8feddc6000 r--p 00000000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8feddc6000-7f8fee050000 r-xp 0002c000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8fee050000-7f8fee149000 r--p 002b6000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8fee149000-7f8fee14a000 r--p 003af000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8fee14a000-7f8fee153000 r--p 003af000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8fee153000-7f8fee154000 rw-p 003b8000 fe:01 2886112                    /usr/local/lib/libruby.so.2.7.3
7f8fee154000-7f8fee16d000 rw-p 00000000 00:00 0 
7f8fee16d000-7f8fee182000 r--p 00000000 fe:01 2884174                    /lib/ld-musl-x86_64.so.1
7f8fee182000-7f8fee1ca000 r-xp 00015000 fe:01 2884174                    /lib/ld-musl-x86_64.so.1
7f8fee1ca000-7f8fee200000 r--p 0005d000 fe:01 2884174                    /lib/ld-musl-x86_64.so.1
7f8fee200000-7f8fee201000 r--p 00092000 fe:01 2884174                    /lib/ld-musl-x86_64.so.1
7f8fee201000-7f8fee202000 rw-p 00093000 fe:01 2884174                    /lib/ld-musl-x86_64.so.1
7f8fee202000-7f8fee205000 rw-p 00000000 00:00 0 
7ffef0e2a000-7ffef1629000 rw-p 00000000 00:00 0                          [stack]
7ffef16d5000-7ffef16d9000 r--p 00000000 00:00 0                          [vvar]
7ffef16d9000-7ffef16db000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]


Aborted

===================================
Starting the Jekyll Action
Execute pre-build commands specified by the user.
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/community/x86_64/APKINDEX.tar.gz
(1/44) Installing libxau (1.0.9-r0)
(2/44) Installing libbsd (0.10.0-r0)
(3/44) Installing libxdmcp (1.1.3-r0)
(4/44) Installing libxcb (1.14-r1)
(5/44) Installing libx11 (1.7.0-r0)
(6/44) Installing libxext (1.3.4-r0)
(7/44) Installing libxrender (0.9.10-r3)
(8/44) Installing libbz2 (1.0.8-r1)
(9/44) Installing libpng (1.6.37-r1)
(10/44) Installing freetype (2.10.4-r1)
(11/44) Installing libuuid (2.36.1-r1)
(12/44) Installing fontconfig (2.13.1-r3)
(13/44) Installing pixman (0.40.0-r2)
(14/44) Installing cairo (1.16.0-r2)
(15/44) Installing libexif (0.6.22-r0)
(16/44) Installing fftw-double-libs (3.3.9-r0)
(17/44) Installing giflib (5.2.1-r0)
(18/44) Installing libblkid (2.36.1-r1)
(19/44) Installing libmount (2.36.1-r1)
(20/44) Installing pcre (8.44-r0)
(21/44) Installing glib (2.66.8-r0)
(22/44) Installing aom-libs (1.0.0-r1)
(23/44) Installing libde265 (1.0.4-r0)
(24/44) Installing x265-libs (3.4-r0)
(25/44) Installing libheif (1.9.1-r0)
(26/44) Installing libimagequant (2.13.1-r0)
(27/44) Installing libjpeg-turbo (2.1.0-r0)
(28/44) Installing lcms2 (2.11-r0)
(29/44) Installing orc (0.4.32-r0)
(30/44) Installing cairo-gobject (1.16.0-r2)
(31/44) Installing xz-libs (5.2.5-r0)
(32/44) Installing libxml2 (2.9.10-r6)
(33/44) Installing shared-mime-info (2.0-r0)
(34/44) Installing tiff (4.2.0-r0)
(35/44) Installing gdk-pixbuf (2.42.4-r0)
(36/44) Installing libxft (2.3.3-r0)
(37/44) Installing fribidi (1.0.10-r0)
(38/44) Installing graphite2 (1.3.14-r0)
(39/44) Installing harfbuzz (2.7.4-r1)
(40/44) Installing pango (1.48.2-r0)
(41/44) Installing librsvg (2.50.4-r0)
(42/44) Installing libwebp (1.1.0-r0)
(43/44) Installing vips (8.10.5-r0)
(44/44) Installing vips-tools (8.10.5-r0)
Executing busybox-1.32.1-r6.trigger
Executing shared-mime-info-2.0-r0.trigger
Executing gdk-pixbuf-2.42.4-r0.trigger
OK: 270 MiB in 105 packages
Successfully installed bundler-2.2.16
1 gem installed
        VipsForeignSavePng (pngsave_base), save png (.png), priority=0, rgba
          VipsForeignSavePngFile (pngsave), save image to png file (.png), priority=0, rgba
          VipsForeignSavePngBuffer (pngsave_buffer), save image to png buffer (.png), priority=0, rgba
          VipsForeignSavePngTarget (pngsave_target), save image to target as PNG (.png), priority=0, rgba
        VipsForeignSaveWebp (webpsave_base), save webp (.webp), priority=0, rgba-only
          VipsForeignSaveWebpFile (webpsave), save image to webp file (.webp), priority=0, rgba-only
          VipsForeignSaveWebpBuffer (webpsave_buffer), save image to webp buffer (.webp), priority=0, rgba-only
          VipsForeignSaveWebpTarget (webpsave_target), save image to webp target (.webp), priority=0, rgba-only
        VipsForeignSaveHeif (heifsave_base), save image in HEIF format (.heic, .heif, .avif), priority=0, rgba-only
          VipsForeignSaveHeifFile (heifsave), save image in HEIF format (.heic, .heif, .avif), priority=0, rgba-only
          VipsForeignSaveHeifBuffer (heifsave_buffer), save image in HEIF format (.heic, .heif, .avif), priority=0, rgba-only
          VipsForeignSaveHeifTarget (heifsave_target), save image in HEIF format (.heic, .heif, .avif), priority=0, rgba-only
::debug::Source directory is set via input parameter
::debug::Using "/jekyll-jpt-avif" as a source directory
::debug::Gem directory is set via input parameter
::debug::Using "/jekyll-jpt-avif" as Gem directory
::debug::Environment is set via input parameter
::debug::target branch is set via input parameter
::debug::Remote is https://:FAKE-TOKEN@github.com/.git
::debug::Build dir is /github/workspace/../jekyll_build
::debug::Initializing new repo
Initialized empty Git repository in /github/jekyll_build/.git/
::debug::Local branch is main
::debug::ChangeDir to /github/workspace//jekyll-jpt-avif
::debug::Bundle config set succesfully
Fetching gem metadata from https://rubygems.org/..........
Resolving dependencies...
Using bundler 2.2.16
Fetching colorator 1.1.0
Fetching concurrent-ruby 1.1.8
Fetching public_suffix 4.0.6
Fetching eventmachine 1.2.7
Installing colorator 1.1.0
Installing public_suffix 4.0.6
Fetching http_parser.rb 0.6.0
Installing eventmachine 1.2.7 with native extensions
Installing concurrent-ruby 1.1.8
Installing http_parser.rb 0.6.0 with native extensions
Fetching ffi 1.15.0
Installing ffi 1.15.0 with native extensions
Fetching forwardable-extended 2.6.0
Installing forwardable-extended 2.6.0
Fetching rb-fsevent 0.10.4
Fetching rexml 3.2.5
Installing rexml 3.2.5
Installing rb-fsevent 0.10.4
Fetching liquid 4.0.3
Fetching rouge 3.26.0
Fetching mercenary 0.4.0
Fetching safe_yaml 1.0.5
Installing liquid 4.0.3
Installing safe_yaml 1.0.5
Installing mercenary 0.4.0
Installing rouge 3.26.0
Fetching unicode-display_width 1.7.0
Installing unicode-display_width 1.7.0
Fetching mime-types-data 3.2021.0225
Fetching objective_elements 1.1.2
Installing mime-types-data 3.2021.0225
Installing objective_elements 1.1.2
Fetching rainbow 3.0.0
Installing rainbow 3.0.0
Fetching addressable 2.7.0
Fetching i18n 1.8.10
Installing addressable 2.7.0
Installing i18n 1.8.10
Fetching pathutil 0.16.2
Installing pathutil 0.16.2
Fetching kramdown 2.3.1
Fetching sassc 2.4.0
Fetching rb-inotify 0.10.1
Installing rb-inotify 0.10.1
Installing kramdown 2.3.1
Installing sassc 2.4.0 with native extensions
Fetching ruby-vips 2.0.17
Installing ruby-vips 2.0.17
Fetching em-websocket 0.5.2
Installing em-websocket 0.5.2
Fetching terminal-table 2.0.0
Installing terminal-table 2.0.0
Fetching mime-types 3.3.1
Installing mime-types 3.3.1
Fetching listen 3.5.1
Fetching kramdown-parser-gfm 1.1.0
Fetching jekyll-sass-converter 2.1.0
Installing kramdown-parser-gfm 1.1.0
Installing jekyll-sass-converter 2.1.0
Installing listen 3.5.1
Fetching jekyll-watch 2.2.1
Installing jekyll-watch 2.2.1
Fetching jekyll 4.2.0
Installing jekyll 4.2.0
Fetching jekyll_picture_tag 2.0.3
Installing jekyll_picture_tag 2.0.3
Bundle complete! 2 Gemfile dependencies, 34 gems now installed.
Bundled gems are installed into `./vendor/bundle`
::debug::Completed bundle install
::debug::Jekyll debug is on
  Logging at level: debug
    Jekyll Version: 4.2.0
Configuration file: /github/workspace/jekyll-jpt-avif/_config.yml
         Requiring: jekyll_picture_tag
            Source: /github/workspace/jekyll-jpt-avif
       Destination: /github/jekyll_build
 Incremental build: disabled. Enable with --incremental
      Generating... 
           Reading: /_layouts/default.html
           Reading: /_layouts/post.html
       EntryFilter: excluded /.jekyll-cache
       EntryFilter: excluded /Gemfile
       EntryFilter: excluded /Gemfile.lock
           Reading: assets/css/style.scss
       EntryFilter: excluded /vendor/bundle
           Reading: another-page.md
           Reading: index.md
         Rendering: another-page.md
  Pre-Render Hooks: another-page.md
  Rendering Markup: another-page.md
Post-Convert Hooks: another-page.md
  Rendering Layout: another-page.md
Generating new image file: /assets/img/logo-400-73a16b8ad.avif
Project jekyll-jpt-avif build: FAILED ❌
Generated site in: ./build/jekyll-jpt-avif/
===================================

```

### Question

Where does the problem come from?

Well, I don't know and I will ask the mainteners of `jekyll-action` and  `jekyll_picture_tag` projects!
