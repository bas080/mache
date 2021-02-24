#!/usr/bin/env bash

# shellcheck source=t/dependencies.sh
source <(./t/dependencies.sh)

plan 2

shellcheck ./mache | diagnostics
test_success "Mache passes shellcheck."

shellcheck -x ./t/*.t 2>&1 | diagnostics
test_success "Tests pass shellcheck"
