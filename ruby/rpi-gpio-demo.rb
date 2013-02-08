#!/usr/bin/env ruby19

require 'gpio'

def flags2str (flags)
  strs = Array.new

  strs << 'INPUT' if ((flags & GPIO_PIN_INPUT) != 0)
  strs << 'OUTPUT' if ((flags & GPIO_PIN_OUTPUT) != 0)
  strs << 'OPENDRAIN' if ((flags & GPIO_PIN_OPENDRAIN) != 0)
  strs << 'PUSHPULL' if ((flags & GPIO_PIN_PUSHPULL) != 0)
  strs << 'TRISTATE' if ((flags & GPIO_PIN_TRISTATE) != 0)
  strs << 'PULLUP' if ((flags & GPIO_PIN_PULLUP) != 0)
  strs << 'PULLDOWN' if ((flags & GPIO_PIN_PULLDOWN) != 0)
  strs << 'INVIN' if ((flags & GPIO_PIN_INVIN) != 0)
  strs << 'INVOUT' if ((flags & GPIO_PIN_INVOUT) != 0)
  strs << 'PULSATE' if ((flags & GPIO_PIN_PULSATE) != 0)

  return strs.join(",")
end

gpioc = GpioController.new("/dev/gpioc0")
pins = gpioc.max_pin + 1
puts "Max pin #: #{pins-1}"
pins.times do |p|
  pin = gpioc.pin(p)
  next unless pin.valid?

  caps = flags2str(pin.caps)
  config = flags2str(pin.config)
  name = pin.name
  value = pin.value

  puts "##{p}: name=#{name}, value=#{value}, config=<#{config}>, caps=<#{caps}>"
end

# LED pin seems to be active LOW
led_pin = gpioc.pin(16)

# pin LOW, led is ON
led_pin.value = GPIO_LOW
sleep(1)

# pin HIGH, led is OFF
led_pin.value = GPIO_HIGH
sleep(1)

100.times do 
  led_pin.toggle
  sleep(0.05)
end
