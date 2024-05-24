#!/usr/bin/env bash

source bash-tap

plan 2

shellcheck ./mache | diagnostics
test_success "Mache passes shellcheck."

shellcheck -x ./t/*.t 2>&1 | diagnostics
test_success "Tests pass shellcheck"
