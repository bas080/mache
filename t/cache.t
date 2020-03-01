#!/usr/bin/env bash

source <(./t/dependencies.sh)

plan 1

diff <(./t/date) <(sleep 2; ./t/date)

test_success "Fetches the previously cached date."
