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

require 'gpio/bsdgpio'

GPIO_LOW  = 0
GPIO_HIGH = 1

GPIO_PIN_INPUT      = 0x0001  
GPIO_PIN_OUTPUT     = 0x0002  
GPIO_PIN_OPENDRAIN  = 0x0004  
GPIO_PIN_PUSHPULL   = 0x0008  
GPIO_PIN_TRISTATE   = 0x0010  
GPIO_PIN_PULLUP     = 0x0020  
GPIO_PIN_PULLDOWN   = 0x0040  
GPIO_PIN_INVIN      = 0x0080  
GPIO_PIN_INVOUT     = 0x0100  
GPIO_PIN_PULSATE    = 0x0200  

class GpioPin
  attr_accessor :value, :config

  def initialize(controller,  pinno)
    @controller = controller
    @pinno = pinno
  end

  def valid?
    return @controller.pin_valid?(@pinno)
  end

  def name
    return @controller.get_pin_name(@pinno)
  end 

  def caps
    return @controller.get_pin_caps(@pinno)
  end 

  def value
    return @controller.get_pin_value(@pinno)
  end 

  def value=(v)
    return @controller.set_pin_value(@pinno, v)
  end

  def toggle
    return @controller.toggle_pin_value(@pinno)
  end

  def config
    return @controller.get_pin_config(@pinno)
  end 

  def config=(c)
    return @controller.set_pin_config(@pinno, c)
  end

end

class GpioController
  def initialize(dev)
    @device_name = dev
    @file = File.open(dev, 'r')
    @fd = @file.fileno
  end

  def close
    if @file then
      @file.close
      @fd = -1
    end
  end

  def pin(pinno)
    return GpioPin.new(self, pinno)
  end

  def max_pin
    return BsdGpio::max_pin(@fd);
  end

  def pin_valid?(pinno)
    return BsdGpio::is_pin_valid(@fd, pinno);
  end

  def get_pin_caps(pinno)
    return BsdGpio::get_pin_caps(@fd, pinno);
  end

  def get_pin_name(pinno)
    return BsdGpio::get_pin_name(@fd, pinno);
  end

  def get_pin_value(pinno)
    return BsdGpio::get_pin_value(@fd, pinno);
  end

  def set_pin_value(pinno, value)
    return BsdGpio::set_pin_value(@fd, pinno, value);
  end

  def toggle_pin_value(pinno)
    return BsdGpio::toggle_pin_value(@fd, pinno);
  end

  def get_pin_config(pinno)
    return BsdGpio::get_pin_config(@fd, pinno);
  end

  def set_pin_config(pinno, config)
    return BsdGpio::set_pin_config(@fd, pinno, config);
  end

end
