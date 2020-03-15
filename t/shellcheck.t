#!/usr/bin/env bash

source <(./t/dependencies.sh)

plan 1

shellcheck ./mache | diagnostics

test_success "Mache passes shellcheck."
