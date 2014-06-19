# install MDBM_File from github

[mdbm](https://github.com/yahoo/mdbm) has the official perl binding MDBM_File.

This repository helps you install it. I hope yahoo upload MDBM_File to cpan.

## how to install

Just one line:

    > cpanm git://github.com/shoichikaji/perl-mdbm-install.git

    # if you don't have cpanm, try
    > curl -sL http://cpanmin.us | perl - git://github.com/shoichikaji/perl-mdbm-install.git

Or with Carton v1.0.901+:

    > cat cpanfile
    requires 'MDBM_File', 0, git => 'git://github.com/shoichikaji/perl-mdbm-install.git';

    > carton install
    Installing modules using /home/skaji/cpanfile
    Successfully installed MDBM_File-2
    1 distribution installed
    Complete! Modules were installed into /home/skaji/local

## requirement

* Linux (currently mdbm cannot be compiled on MacOS)
* perl
* git
* c,c++ compiler

## eg

From SYNOPSIS (type `perldoc MDBM_File` for more detail):

```perl
use MDBM_File;
use Fcntl;

my $mdbm_obj = tie(%h, 'MDBM_File', 'file.mdbm', MDBM_O_RDWR|MDBM_O_CREAT, 0640 );

undef($mdbm_obj);
untie %h;

tie(%h, 'MDBM_File', 'file.mdbm', O_RDWR|O_CREAT, 0640, $pagesize, $dbsize );
my $mdbm_obj = tied %h; # You can also get this as the response from tie() above
$mdbm_obj->lock();
$h{'key'}++;
$mdbm_obj->unlock();
delete $h{'key'};

untie %h;
```
