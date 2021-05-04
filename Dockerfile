FROM ruby:2.7-alpine

LABEL version="2.0.1"
LABEL repository="https://github.com/helaili/jekyll-action"
LABEL homepage="https://github.com/helaili/jekyll-action"
LABEL maintainer="Alain Hélaïli <helaili@github.com>"

RUN apk add --no-cache git build-base
# Allow for timezone setting in _config.yml
RUN apk add --update tzdata
# Use curl to send API requests
RUN apk add --update curl
# Install VIPS
RUN apk add --update vips vips-tools
# Update bundler to same as local dev
# RUN gem install bundler:2.2.15

# debug
RUN bundle version
RUN ruby --version
RUN vips --version
RUN ulimit -a

COPY LICENSE README.md /

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
