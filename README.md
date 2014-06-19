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

## requirement

* Linux (currently mdbm cannot be compiled on MacOS)
* perl
* git
* c,c++ compiler
