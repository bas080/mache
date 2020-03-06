# Mache <>

Memoize stdout of any process.

- The code is concise and written in Bash.
- Only caches stdout of processes that exit with status code 0, which avoids
  a bunch of edge cases.
- Will recache when the contents of the script changes or the arguments
  supplied to it change.
- Has a REMACHE variable which will refresh your caches.

## Usage

> Notice how it outputs the same date. It's using the cache. If we supply
> different options it will create a new cache.

```
$ mache date
vr  6 mrt 2020 17:13:57 CET
$ mache date
vr  6 mrt 2020 17:13:57 CET

# NOTE: Make sure to pass command as a single argument.
# Bash will otherwise expand the options.
$ mache 'date -d "1 Apr 2020"'
wo  1 apr 2020  0:00:00 CEST
 'date -d "2 Apr 2020"'
do  2 apr 2020  0:00:00 CEST
```

You can also provide a script with arguments. This does not require one to
quote the complete command.

```
$ mache ./t/echo hello
hello
$ mache ./t/echo hello "vr  6 mrt 2020 18:46:48 CET"
hello vr 6 mrt 2020 18:46:48 CET
```

You can also make a mache script. These scripts will cache by default. Simply
define the following shebang at the top of that script.

```
#!/usr/bin/env mache
#!/usr/bin/env bash

date "$@"
```

We can now run that script assuming you made it executable. (chmod +x ./t/date)

```
$ ./t/date
vr  6 mrt 2020 18:46:31 CET
```


By default mache will use the cache if present. You can remake the cache:

```
$ REMACHE=1 ./t/date
vr  6 mrt 2020 18:46:48 CET
sleep 2 
$ REMACHE=1 ./t/date
vr  6 mrt 2020 18:46:50 CET
```

A mache script does not cache when the script exits with non zero.

The arguments/options that are passed to the mache script are taken into
account when checking if cache should be used. Different values will result in
the mache script being re-evaluated. [memoization][3]

## Tests

Tests can be run with perl's [prove][2] command; or execute a single one:

`./t/cache.t`

## Known Issues

- Caching can result in hard to find bugs because it isn't clear which version
  of the output is being used. When caching, cache thoughtfully and invalidate
  a cache when in doubt.

## License

GNU General Public License 3.0

[1]:./t/date
[2]:https://perldoc.perl.org/prove.html
[3]:https://en.wikipedia.org/wiki/Memoization
