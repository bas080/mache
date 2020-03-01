#!/usr/bin/env bash

source <(./t/dependencies.sh)

plan 1

chmod =w ./README.md
./README | tee ./README.md | diagnostics
chmod =r ./README.md

test_success "Generates the README.md"
