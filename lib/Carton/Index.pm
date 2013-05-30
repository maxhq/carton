package Carton::Index;
use strict;

sub new {
    my($class, $packages) = @_;
    bless { packages => {} }, $class;
}

sub add_package {
    my($self, $package) = @_;
    $self->{packages}{$package->name} ||= $package;
}

sub count {
    my $self = shift;
    scalar keys %{$self->{packages}};
}

sub packages {
    my $self = shift;
    sort { $a->name cmp $b->name } values %{$self->{packages}};
}

sub write {
    my($self, $fh) = @_;

    print $fh <<EOF;
File:         02packages.details.txt
URL:          http://www.perl.com/CPAN/modules/02packages.details.txt
Description:  Package names found in carton.lock
Columns:      package name, version, path
Intended-For: Automated fetch routines, namespace documentation.
Written-By:   Carton $Carton::VERSION
Line-Count:   @{[ $self->count ]}
Last-Updated: @{[ scalar localtime ]}

EOF
    for my $p ($self->packages) {
        print $fh sprintf "%s %s  %s\n", pad($p->name, 32), pad($p->version || 'undef', 10, 1), $p->pathname;
    }
}

sub pad {
    my($str, $len, $left) = @_;

    my $howmany = $len - length($str);
    return $str if $howmany <= 0;

    my $pad = " " x $howmany;
    return $left ? "$pad$str" : "$str$pad";
}


1;