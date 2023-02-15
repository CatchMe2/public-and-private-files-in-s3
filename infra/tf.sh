#!/bin/bash

docker run --rm -it -u "$(id -u):$(id -g)" \
  -v "${PWD}:/infra" -w "/infra" \
  -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
  -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
  hashicorp/terraform:1.3.8 "$@"
