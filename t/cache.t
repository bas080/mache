#!/usr/bin/env bash

# shellcheck source=t/dependencies.sh
source <(./t/dependencies.sh)

plan 1

diff <(./t/date) <(sleep 1; ./t/date) | diagnostics

test_success "Fetches the previously cached date."
