#!/bin/bash

JEKYLL_PROJECTS=(jekyll-basic jekyll-jpt-webp jekyll-jpt-avif )

for PROJECT in "${JEKYLL_PROJECTS[@]}"
do

  #rm -rf ${PWD}/build/${PROJECT}

  RESULT=$(docker run --name jekyll-test-action-basic --label ${PROJECT} \
  --workdir /github/workspace \
  --rm \
  -e JEKYLL_DEBUG='true' \
  -e INPUT_TOKEN='FAKE-TOKEN' \
  -e INPUT_TARGET_BRANCH='main' \
  -e INPUT_JEKYLL_BUILD_OPTIONS='--verbose' \
  -e INPUT_BUILD_ONLY=true \
  -e INPUT_PRE_BUILD_COMMANDS='' \
  -e INPUT_JEKYLL_ENV='production' \
  -e INPUT_JEKYLL_SRC="/${PROJECT}" \
  -e INPUT_GEM_SRC="/${PROJECT}" \
  -e INPUT_TARGET_PATH \
  -e INPUT_KEEP_HISTORY \
  -e GITHUB_JOB \
  -e GITHUB_REF \
  -e GITHUB_SHA \
  -e GITHUB_REPOSITORY \
  -e GITHUB_REPOSITORY_OWNER \
  -e GITHUB_RUN_ID \
  -e GITHUB_RUN_NUMBER \
  -e GITHUB_RETENTION_DAYS \
  -e GITHUB_ACTOR \
  -e GITHUB_WORKFLOW \
  -e GITHUB_HEAD_REF \
  -e GITHUB_BASE_REF \
  -e GITHUB_EVENT_NAME \
  -e GITHUB_SERVER_URL \
  -e GITHUB_API_URL \
  -e GITHUB_GRAPHQL_URL \
  -e GITHUB_WORKSPACE='/github/workspace' \
  -e GITHUB_ACTION \
  -e GITHUB_EVENT_PATH \
  -e GITHUB_ACTION_REPOSITORY \
  -e GITHUB_ACTION_REF \
  -e GITHUB_PATH \
  -e GITHUB_ENV \
  -e RUNNER_OS \
  -e RUNNER_TOOL_CACHE \
  -e RUNNER_TEMP \
  -e RUNNER_WORKSPACE \
  -e ACTIONS_RUNTIME_URL \
  -e ACTIONS_RUNTIME_TOKEN \
  -e ACTIONS_CACHE_URL \
  -e GITHUB_ACTIONS=true \
  -e CI=true \
  -v "/var/run/docker.sock":"/var/run/docker.sock" \
  -v "${PWD}/tmp":"/github/home" \
  -v "${PWD}/tmp":"/github/workflow" \
  -v "${PWD}/tmp":"/github/file_commands" \
  -v "${PWD}":"/github/workspace" \
  -v "${PWD}/build/${PROJECT}":"/github/workspace/../jekyll_build" \
  jekyll-test-actions:latest
  )

  if [ -f "${PWD}/build/${PROJECT}/index.html" ]; then
    echo "Project ${PROJECT} built: SUCCESS ✅"
  else
    echo "Project ${PROJECT} built: FAILED ❌"
  fi

done