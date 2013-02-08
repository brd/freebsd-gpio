# Copyright (c) 2013 Oleksandr Tymoshenko <gonzo@bluezbox.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
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

import os
import _bsdgpio

PIN_INPUT       = 0x0001
PIN_OUTPUT      = 0x0002
PIN_OPENDRAIN   = 0x0004
PIN_PUSHPULL    = 0x0008
PIN_TRISTATE    = 0x0010
PIN_PULLUP      = 0x0020
PIN_PULLDOWN    = 0x0040
PIN_INVIN       = 0x0080
PIN_INVOUT      = 0x0100
PIN_PULSATE     = 0x0200

LOW             = 0
HIGH            = 1

class GpioError(Exception):
    pass

class GpioPin(object):
    def __init__(self, controller, pinnum):
        self.controller = controller
        self.number = pinnum

    @property 
    def value(self):
        return self.controller.get_pin_value(self.number)

    @value.setter
    def value(self, value):
        return self.controller.set_pin_value(self.number, value)

    def toggle(self):
        return self.controller.toggle_pin(self.number)

    @property
    def caps(self):
        return self.controller.get_pin_caps(self.number)

    @property
    def name(self):
        return self.controller.get_pin_name(self.number)

    @property
    def config(self):
        return self.controller.get_pin_config(self.number)

    @config.setter
    def config(self, config):
        return self.controller.set_pin_config(self.number, config)

class GpioController(object):
    def __init__ (self, dev):
        self._fd =  os.open(dev, os.O_RDONLY)

    def __del__(self):
        os.close(self._fd)

    def pin(self, pinnum):
        return GpioPin(self, pinnum)

    def get_pin_value(self, pinnum):
        try:
            v = _bsdgpio.get_value(self._fd, pinnum)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return v

    def set_pin_value(self, pinnum, value):
        try:
            _bsdgpio.set_value(self._fd, pinnum, value)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)

    def toggle_pin(self, pinnum):
        try:
            v = _bsdgpio.toggle_value(self._fd, pinnum)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return v

    def get_pin_config(self, pinnum):
        try:
            config = _bsdgpio.get_config(self._fd, pinnum)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return config

    def set_pin_config(self, pinnum, config):
        try:
            _bsdgpio.set_config(self._fd, pinnum, config)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)

    def get_pin_caps(self, pinnum):
        try:
            caps = _bsdgpio.get_caps(self._fd, pinnum)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return caps

    def get_pin_name(self, pinnum):
        try:
            name = _bsdgpio.get_name(self._fd, pinnum)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return name

    @property 
    def max_pin(self):
        try:
            max_pin = _bsdgpio.get_max_pin(self._fd)
        except _bsdgpio.error as e:
            # re-raise public exception
            raise GpioError(e)
        return max_pin

def controller (dev = "/dev/gpioc0"):
    return GpioController(dev)

if __name__ == "__main__":
    pass
