# Mache

Cache stdout of any process.

- The code is concise and written in Bash.
- Only caches stdout of processes that exit with status code 0, which avoids
  a bunch of edge cases.
- Will re-cache when the contents of the script changes or the arguments
  supplied to it change.
- Has a REMACHE variable which will refresh your caches.
- Define the cache file with MACHE_TARGET. Handy when doing builds.

## Usage

Notice how it outputs the same date. It's using the cache.

```bash
$ mache date
di 17 mrt 2020 17:13:47 CET
$ mache date
di 17 mrt 2020 17:13:47 CET
```

If we supply different options it will create a new cache.

```bash
$ mache 'date -d "1 Apr 2020"'
wo  1 apr 2020  0:00:00 CEST
$ mache 'date -d "2 Apr 2020"'
do  2 apr 2020  0:00:00 CEST
```

You can also provide a script with arguments. This does not require one to
quote the complete command.

```bash
$ mache /bin/echo hello
hello
$ mache /bin/echo hello world
hello world
```

> Notice that it recomputes the cache for both commands separately. This is
> because the options are not equal.

You can also make a mache script. These scripts will cache by default. Simply
define the following shebang at the top of that script.

```bash
$ cat ./t/date
#!/usr/bin/env mache
#!/usr/bin/env bash

date "$@"
```

We can now run that script assuming you made it executable. (chmod +x ./t/date)

```bash
$ ./t/date
wo 27 mei 2020 14:03:37 CEST
```

By default mache will use the cache if present. You can remake the cache:

```bash
$ REMACHE=1 ./t/date
wo 27 mei 2020 14:15:25 CEST
$ sleep 2

$ REMACHE=1 ./t/date
wo 27 mei 2020 14:15:27 CEST
```

A mache script does not cache when the script exits with non zero.

The arguments/options that are passed to the mache script are taken into
account when checking if cache should be used. Different values will result in
the mache script being re-evaluated. [memoization][3]

## Applications

### Periodic backups

Use mache to make backups every week.
Create a mache script:

```bash
$ cat $HOME/.bash_backup
#!/usr/bin/env mache
#!/usr/bin/env bash

{
  location="/media/$USER/passport"

  >&2 printf "%s?\n" "$location"
  read -p "" < /dev/tty

  $HOME/.local/bin/backup "$location"
} > /dev/null

printf 'echo "Latest Backup: %s\n"' "$(date)"
```

Also add the following to your `.bashrc`.

```bash
$ grep 'bash_backup' < $HOME/.bashrc
  $HOME/.bash_backup "$(date +'%V-%G')"
```

This means that the backup script will be sourced every time the week number
changes. Otherwise the cache is sourced.

### Remote dependencies

Bash has no dependency management. Bash does allow one to source just about
anything. Mache allows one to depend on a remote file and cache it for offline
use. No need to re-download every time the script is run.

We can define a dependencies.sh and source it in files that depend on that
script. This project contains an example of that in the tests.

```bash
$ cat ./t/dependencies.sh
#!/usr/bin/env mache
#!/usr/bin/env bash

curl -s https://raw.githubusercontent.com/bas080/bash-tap/83132cc81696a49f4e4c66b126a63bcba0633018/bash-tap
```

Now for the tests.

```bash
$ cat ./t/cache.t
#!/usr/bin/env bash

source <(./t/dependencies.sh)

plan 1

diff <(./t/date) <(sleep 1; ./t/date) | diagnostics

test_success "Fetches the previously cached date."
```

When running the tests it will run curl only when the cache is not present or
when REMACHE is defined.

```bash
$ ./t/cache.t
1..1
# 
ok - Fetches the previously cached date.
```

Rerunning the tests will result in the cache being used. Changes to the
dependencies will have mache update the cache.

### Installation and Update

Often tools like leiningen and nvm require a bash script to be sourced. One can
simply use mache to not just install but also update these regularly. See the
periodic backup example.

### Optimization

Caches can help increase the performance considerably. It should however be
used thoughtfully.

### Bundling/Building files

Mache can be used to bundle/build files of a project. You can define the
`MACHE_TARGET` variable. In that case it writes the outputs of the mache script
to that file.

## Tests

Tests can be run with Perl's [prove][2] command; or execute a single one:

```bash
$ ./t/cache.t
1..1
# 
ok - Fetches the previously cached date.

$ prove
t/README.t ....... skipped: Do not recur.
t/cache.t ........ ok
t/machetarget.t .. ok
t/nocache.t ...... ok
t/shellcheck.t ... ok
All tests successful.
Files=5, Tests=5,  3 wallclock secs ( 0.02 usr  0.01 sys +  0.16 cusr  0.05 csys =  0.24 CPU)
Result: PASS
```

## Known Issues

- Caching can result in hard to find bugs because it isn't clear which version
  of the output is being used. When caching, cache thoughtfully and invalidate
  a cache when in doubt.

## Documentation

Generating the documentation requires [barkdown][4].

`./README.bd > ./README.md`

## License

GNU General Public License 3.0

[1]:./t/date
[2]:https://perldoc.perl.org/prove.html
[3]:https://en.wikipedia.org/wiki/Memoization
[4]:https://github.com/bas080/barkdown
