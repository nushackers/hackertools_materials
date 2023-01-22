# Commands for data wrangling workshop

First iteration with sed
```sh
cat log | grep sshd | grep "Accepted publickey for" | sed 's/.*Accepted publickey for //'
```

Demo for "publickey for"
```sh
echo Mar 21 14:40:52 juliuspts-512mb-sgp1-1540046100423-s-1vcpu-1gb-sgp1-01 sshd[10486]: Accepted publickey for Accepted publickey for from 137.132.213.204 port 45476 ssh2: RSA SHA256:bu90QiNcKQbWqDbslyrd56AErYav9GuUVrjri1XlZKQ | grep sshd | grep "Accepted publickey for" | sed 's/.*Accepted publickey for //'
```

Notice how the username "Accepted publickey for" is now missing.

Remedy it:
```
echo Mar 21 14:40:52 juliuspts-512mb-sgp1-1540046100423-s-1vcpu-1gb-sgp1-01 sshd[10486]: Accepted publickey for Accepted publickey for from 137.132.213.204 port 45476 ssh2: RSA SHA256:bu90QiNcKQbWqDbslyrd56AErYav9GuUVrjri1XlZKQ | grep sshd | grep "Accepted publickey for" | sed -E 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1 \2:\3/'
```

Entire pipeline
```sh
cat log | grep sshd | grep "Accepted publickey for" | sed -E 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*//'
```

Entire pipeline - names captured \1 -> names, \2 -> ip, \3 -> port number
```sh
cat log | grep sshd | grep "Accepted publickey for" | sed -E 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/'
```

Entire pipeline - without grep by using -!d to filter lines we don't care about.
```sh
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/'
```

Entire pipeline - sort by name, filter unique names, provide count
```sh
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c
```

numeric vs lexical sorting
```
seq 1 20 | sort
seq 1 20 | sort -n
```

top 3 most common
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | tail -n3
```

top 3 least common
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | head -n3
```

Only usernames, not one per line. paste combines lines with `-s`, `d,` sets delimiter to `,`,
`-` tells us to read from stdin.
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | head -n3 | awk '{print $2}' | paste -sd, -
```

single-use usernames
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | awk '$1 == 1 && $2 ~ /^r[^ ]*t/ {print $2}'
```

count single-use usernames
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | awk 'BEGIN { rows = 0 } $1 == 1 && $2 ~ /^r[^ ]*t$/ {rows += $1} END{ print rows }'
```

quick maths
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | awk '{print $1}' | paste -sd+ - | bc
```

xargs
```
cat log | sed -E -e '/Accepted publickey for/!d' -e 's/.*Accepted publickey for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) port ([0-9]+) ssh2: RSA SHA256:.*/\1/' | sort | uniq -c | sort -nk1,1 | awk '{print $1}' | xargs echo
```

removing files **PROCEED WITH CAUTION**:
```
ls | grep -E 'asd.a [0-9]{2}' | xargs rm
```

removing files **PROCEED WITH CAUTION**, properly...:
```
ls | grep -E 'asd.a [0-9]{2}' | tr '\n' '\0' | xargs -0 rm
```

restore
```
git checkout -- tmp
```
