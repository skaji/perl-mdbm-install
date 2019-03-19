# Install MDBM_File from github

[mdbm](https://github.com/yahoo/mdbm) has the official perl binding MDBM_File.

This repository helps you install it. I hope yahoo upload MDBM_File to cpan.

## Install

```console
cpanm https://github.com/skaji/perl-mdbm-install.git
```

## Requirement

* perl
* git
* c,c++ compiler

## Eg

```perl
use strict;
use warnings;
use MDBM_File qw(MDBM_O_RDONLY MDBM_OPEN_NOLOCK);

tie my %mdbm, 'MDBM_File', 'file.mdbm', MDBM_O_RDONLY|MDBM_OPEN_NOLOCK, 0644
    or die "file.mdbm: $!";

for my $key (sort keys %mdbm) {
    print "$key -> $mdbm{$key}\n";
}

untie %mdbm;
```

See `perldoc MDBM_File`.
