# Copyright (c) 2013 Oleksandr Tymoshenko <gonzo@bluezbox.com>
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

package GPIO;

use warnings;
use strict;

our $VERSION = '0.01';

sub new
{
    my ($class) = @_;

    my $self = ();
    $self->{fd} = -1;
    bless $self, $class;
}

sub open
{
    my ($self, $dev) = @_;

    $dev = "/dev/gpioc0" if (!defined($dev));

    if (open F, "< $dev") {
        $self->{file} = *F;
        $self->{fd} = fileno(F);
        return 1;
    }

    return;
}

sub close
{
    my $self = shift;

    if ($self->{fd} != -1) {
        close $self->{file};
        $self->{fd} = -1;
    }
}

sub get_max_pin
{
    my $self = shift;

    return _get_max_pin($self->{fd});
}

sub is_pin_valid
{
    my ($self, $pin) = @_;

    return _is_pin_valid($self->{fd}, $pin);
}

sub get_pin_name
{
    my ($self, $pin) = @_;

    return _get_pin_name($self->{fd}, $pin);
}

sub get_pin_caps
{
    my ($self, $pin) = @_;

    return _get_pin_caps($self->{fd}, $pin);
}

sub get_pin_config
{
    my ($self, $pin) = @_;

    return _get_pin_config($self->{fd}, $pin);
}

sub set_pin_config
{
    my ($self, $pin, $config) = @_;

    return _set_pin_config($self->{fd}, $pin, $config);
}

sub get_pin_value
{
    my ($self, $pin) = @_;

    return _get_pin_value($self->{fd}, $pin);
}

sub set_pin_value
{
    my ($self, $pin, $value) = @_;

    return _set_pin_value($self->{fd}, $pin, $value);
}

sub toggle_pin_value
{
    my ($self, $pin) = @_;

    return _toggle_pin_value($self->{fd}, $pin);
}

require XSLoader;
XSLoader::load('GPIO', $VERSION);

1;
__END__;

=head1 NAME

GPIO - Perl module for working with GPIO on FreeBSD

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Module provides access to GPIO interface on FreeBSD OS

Example:

    use GPIO;

    my $controller = GPIO->new();
    # Configure pin 17 as output
    $controller->set_pin_config(17, OUTPUT);
    # Set pin 17 to 1
    $controller->set_pin_value(17, 1);
    # Toggle value for pin 17
    $controller->togge_pin_value(17);
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head1 AUTHOR

Oleksandr Tymoshenko, C<< <gonzo at bluezbox.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<gonzo at bluezbox.com>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc GPIO

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Oleksandr Tymoshenko.

This module is free software; you can redistribute it and/or
modify it under the terms of the BSD license. See the F<LICENSE> file
included with this distribution.

=cut

1; # End of GPIO
