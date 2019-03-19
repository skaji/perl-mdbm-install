use strict;
use warnings;
use ExtUtils::MakeMaker 7.34;
use File::Spec;
use FindBin;
sub run { !system @_ or do { warn "FAIL @_\n"; exit } }

my $bindir;
if (!grep { -x "$_/git" && !-d _ } File::Spec->path) {
    warn "Need git command, exit"; exit;
}
if (!grep { -x "$_/realpath" && !-d _ } File::Spec->path) {
    $bindir = "$FindBin::Bin/temp_bindir";
    if (!-d $bindir) {
        mkdir $bindir or die "mkdir $bindir: $!";
    }
    open my $fh, ">", "$bindir/realpath" or die "open $bindir/realpath: $!";
    print {$fh} qq(#!$^X\nuse Cwd 'abs_path';\nprint abs_path(shift), "\\n";);
    close $fh;
    chmod 0755, "$bindir/realpath";
}

run "git", "clone", "--depth=1", "git://github.com/yahoo/mdbm.git" unless -d "mdbm";
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
\tcd mdbm/src/lib && $make
...
    }
}

my $libs = '';
if ($^O eq 'darwin') {
    for my $path (File::Spec->path) {
        my $try = File::Spec->catfile($path, "brew");
        if (-x $try && !-d $try) {
            $libs = `$try --prefix openssl`;
            chomp $libs;
            $libs = "-L$libs/lib";
        }
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
    LIBS => ["-lm -lpthread -lcrypto -lrt -ldl -lstdc++ $libs"],
    OBJECT => [@object, 'shakedata$(OBJ_EXT)', 'MDBM_File$(OBJ_EXT)'],
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 7.34,
    },
    META_MERGE => {
        dynamic_config => 0,
        'meta-spec' => { version => 2 },
        x_static_install => 0,
    },
;
