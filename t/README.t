#!/usr/bin/env bash

source <(./t/dependencies.sh)

[ -z ${NO_RECUR:-} ] || {
  skip_all "Do not recur."
  exit
}

plan 1

chmod =w ./README.md
NO_RECUR=1 ./README.bd | tee ./README.md | diagnostics
chmod =r ./README.md

test_success "Generates the README.md"
