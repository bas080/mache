# Mache

Memoize output of scripts.

Takes a *"build"* script and stores the stdout in a file. When running the
script again it will fetch the previously cached output.

Define a mache [file][1].

```
#!./mache
#!/usr/bin/env bash

date
```

Make sure it's executable; or run the script with the mache command.

`./t/date`


By default mache will use the cache. This can be disabled:

`NOCACHE=1 ./t/date`


## Tests

Tests can be run with perl's [prove][2] command; or execute a single one:

`./t/cache.t`

## Roadmap

- Support passing arguments to the mache script.

[1]:./t/date
[2]:https://perldoc.perl.org/prove.html
