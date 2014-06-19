use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;
use FindBin;
sub run { !system @_ or do { warn "FAIL @_\n"; exit } }

my $bindir;
unless (grep -x "$_/git", File::Spec->path) {
    warn "Need git command, exit"; exit;
}
unless (grep -x "$_/realpath", File::Spec->path) {
    $bindir = "$FindBin::Bin/temp_bindir";
    unless (-d $bindir) {
        mkdir $bindir or die "mkdir $bindir: $!";
    }
    open my $fh, ">", "$bindir/realpath" or die "open $bindir/realpath: $!";
    print {$fh} qq(#!$^X\nuse Cwd 'abs_path';\nprint abs_path(shift), "\\n";);
    close $fh;
    chmod 0755, "$bindir/realpath";
}

run "git", "clone", "git://github.com/yahoo/mdbm.git" unless -d "mdbm";
my @link = qw(
    MDBM_File.pm MDBM_File.xs
    shakedata.cc shakedata.h
    typemap t
);
unlink $_ for grep -l, @link;
symlink "mdbm/src/perl/$_", $_ for @link;

my @object = map { "mdbm/src/lib/object/$_\$(OBJ_EXT)" } qw(
    hash  log  mdbm_handle_pool  mdbm_lock  mdbm
    mdbm_util multi_lock  shmem  stall_signals
);
{
    package MY;
    sub postamble {
        my $make = ($bindir ? "PATH=$bindir:$ENV{PATH} " : "") . '$(MAKE)';
        <<"...";
@object:
\tcd mdbm/src/lib && $make PEDANTIC='-Wall -pedantic -Wno-variadic-macros -Wno-long-long -Wno-overlength-strings'
...
    }
}

WriteMakefile
    NAME => "MDBM_File",
    VERSION_FROM => "MDBM_File.pm",
    AUTHOR => 'Yahoo! MDBM developers',
    # For LICENSE, please refer to https://github.com/yahoo/mdbm
    # README.md says 'It is being released under the BSD license.'
    LICENSE => 'BSD',
    INC => '-Imdbm/include',
    LIBS => ["-lm -lpthread -lcrypto -lrt -ldl -lstdc++"],
    OBJECT => [@object, 'shakedata$(OBJ_EXT)', 'MDBM_File$(OBJ_EXT)'],
;