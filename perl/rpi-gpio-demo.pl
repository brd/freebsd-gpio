#!/usr/bin/perl -w
# Copyright (C) 2007 by Oleksandr Tymoshenko. All rights reserved.

use strict;
use lib qw(/root/freebsd-gpio/perl/blib/lib/ /root/freebsd-gpio/perl/blib/arch);
use Time::HiRes qw(usleep);
use GPIO;

my $controller = GPIO->new();
$controller->open() or die("Can't open GPIO controller dev: $!");
my $max_pin = $controller->get_max_pin();
print "Max pin #: $max_pin\n";

foreach my $p (0..$max_pin) {
    next if (!$controller->is_pin_valid($p));
    my $name = $controller->get_pin_name($p);
    my $value = $controller->get_pin_value($p);
    my $config = $controller->get_pin_config($p);
    my $caps = $controller->get_pin_caps($p);
    print "#$p: name=$name, value=$value, config=<$config>, caps=<$caps>\n";
}

foreach (0..100) {
    $controller->toggle_pin_value(16);
    usleep(50000);
}

$controller->close();
