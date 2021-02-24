#!/usr/bin/env bash

# shellcheck source=t/dependencies.sh
source <(./t/dependencies.sh)

plan 1

diff <(mache 'echo "%s"' 'hello' 'world') <(printf 'hello\nworld\n') | diagnostics
test_success "Supports printf like templating."
