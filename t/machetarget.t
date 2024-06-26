#!/usr/bin/env bash

source bash-tap

plan 2

target="$PWD/t/machetarget.tmp"

MACHE_TARGET="$target" mache 'echo output' > /dev/null

[ -f "$target" ]
test_success "Created the cache file at the target."

[ ! -w "$target" ]
test_success "Does not have write permission."

rm -f "$target"
