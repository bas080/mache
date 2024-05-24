# Mache

Cache stdout of any process.

- The code is concise and written in Bash.
- Only caches stdout of processes that exit with status code 0, which avoids
  a bunch of edge cases.
- Will re-cache when the contents of the script changes or the options
  supplied to it change.
- Has a REMACHE variable which will refresh your caches.
- Supports printf style formatting.
- Define the cache file with MACHE_TARGET. Handy when doing builds.

## Usage

Notice how it outputs the same date. It's using the cache.

```bash
mache date
sleep 2
mache date
```
```
za 25 mrt 2023 19:25:50 CET
za 25 mrt 2023 19:25:50 CET
```

If we supply different options it will create a new cache.

```bash
mache 'date -d "1 Apr 2020"'
mache 'date -d "2 Apr 2020"'
```
```
wo  1 apr 2020  0:00:00 CEST
do  2 apr 2020  0:00:00 CEST
```

You can also provide a script with arguments. This does not require one to
quote the complete command.

```bash
mache /bin/echo hello
mache /bin/echo hello world
```
```
hello
hello world
```

> Notice that it recomputes the cache for both commands separately. This is
> because the options are not equal.

Use printf style formatting.

```bash
mache 'echo "%s"' hello world
mache 'echo "%s"' 'hello world'
```
```
hello
world
hello world
```

You can also make a mache script. These scripts will cache by default. Simply
define the following shebang at the top of that script.

```bash
cat ./t/date
```
```
#!/usr/bin/env mache
#!/usr/bin/env bash

date "$@"
```

We can now run that script assuming you made it executable. (chmod +x ./t/date)

```bash
./t/date
```
```
vr 24 mei 2024 14:13:28 CEST
```

By default mache will use the cache if present. You can remake the cache:

```bash
./t/date
sleep 2
REMACHE=1 ./t/date
```
```
vr 24 mei 2024 14:13:28 CEST
vr 24 mei 2024 14:13:38 CEST
```

A mache script does not cache when the script exits with non zero.

The arguments/options that are passed to the mache script are taken into
account when checking if cache should be used. Different values will result in
the mache script being re-evaluated. [memoization][memoization]

## Tests

> Requires [bash-tap][bash-tap] to be downloaded and on the `$PATH`.

Tests can be run with Perl's [prove][prove] command; or execute a single one:

```bash
./t/printf.t # run single test

prove # run all tests
```
```
1..1
# 
ok - Supports printf like templating.
t/machetarget.t .. ok
t/printf.t ....... ok
t/shellcheck.t ... ok
All tests successful.
Files=3, Tests=5,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.08 cusr  0.00 csys =  0.10 CPU)
Result: PASS
```

## Caution

Caching can result in hard to find bugs because it isn't clear which version
of the output is being used. When caching, cache thoughtfully and invalidate
a cache when in doubt.

## Documentation

Generating the documentation requires [markatzea][markatzea].

`markatzea ./README.mz > ./README.md`

## Roadmap

- [ ] Use some sort of temporary filesystem for high read and write speeds.
      https://docs.oracle.com/cd/E19683-01/817-3814/6mjcp0r0l/index.html
- [ ] Consider having different cache for different STDIN.
- [ ] Consider having flock be separate from mache command.

## License

GNU General Public License 3.0

[prove]:https://perldoc.perl.org/prove.html
[memoization]:https://en.wikipedia.org/wiki/Memoization
[markatzea]:https://github.com/bas080/markatzea
[bash-tap]:https://github.com/bas080/bash-tap
