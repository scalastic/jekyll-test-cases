#!/bin/bash

echo "Cleaning tests' builds..."

rm -rf ./build
rm -rf ./tmp

JEKYLL_PROJECTS=(jekyll-basic jekyll-jpt-webp jekyll-jpt-avif)

for PROJECT in "${JEKYLL_PROJECTS[@]}"
do
  rm -rf $PROJECT/.jekyll-cache
  rm -rf $PROJECT/vendor
  rm $PROJECT/Gemfile.lock
done

echo "Cleaning done"
