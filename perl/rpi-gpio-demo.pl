#!/usr/bin/perl -w
# Copyright (C) 2007 by Oleksandr Tymoshenko. All rights reserved.

use strict;
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
    my $config = flags2str($controller->get_pin_config($p));
    my $caps = flags2str($controller->get_pin_caps($p));
    print "#$p: name=$name, value=$value, config=<$config>, caps=<$caps>\n";
}


# pin LOW, LED is on
$controller->set_pin_value(16, GPIO::LOW);
sleep(1);

# pin HIGH, LED is on
$controller->set_pin_value(16, GPIO::HIGH);
sleep(1);

# Blink LED
foreach (0..100) {
    $controller->toggle_pin_value(16);
    usleep(50000);
}

$controller->close();

# Helper functions
sub flags2str
{
    my $flags = shift;
    my @s = ();

    push @s, 'INPUT' if ($flags & GPIO::PIN_INPUT);
    push @s, 'OUTPUT' if ($flags & GPIO::PIN_OUTPUT);
    push @s, 'OPENDRAIN' if ($flags & GPIO::PIN_OPENDRAIN);
    push @s, 'PUSHPULL' if ($flags & GPIO::PIN_PUSHPULL);
    push @s, 'TRISTATE' if ($flags & GPIO::PIN_TRISTATE);
    push @s, 'PULLUP' if ($flags & GPIO::PIN_PULLUP);
    push @s, 'PULLDOWN' if ($flags & GPIO::PIN_PULLDOWN);
    push @s, 'INVIN' if ($flags & GPIO::PIN_INVIN);
    push @s, 'INVOUT' if ($flags & GPIO::PIN_INVOUT);
    push @s, 'PULSATE' if ($flags & GPIO::PIN_PULSATE);

    return join (',', @s);
}
