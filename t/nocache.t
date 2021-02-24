#!/usr/bin/env bash

# shellcheck source=t/dependencies.sh
source <(./t/dependencies.sh)

plan 1

! diff <(./t/date) <(sleep 1; REMACHE=1 ./t/date) | diagnostics
test_success "Does not fetch the previously cached data. (REMACHE is defined)"
