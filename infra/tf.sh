#!/bin/bash

docker run --rm -it -u "$(id -u):$(id -g)" \
  -v "${PWD}:/infra" -w "/infra" \
  hashicorp/terraform:1.3.8 "$@"
