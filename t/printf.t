#!/usr/bin/env bash

source bash-tap

plan 1

diff <(mache 'echo "%s"' 'hello' 'world') <(printf 'hello\nworld\n') | diagnostics
test_success "Supports printf like templating."
