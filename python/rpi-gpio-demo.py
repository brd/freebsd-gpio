#!/usr/bin/env python

from time import sleep
import gpio

def flags2str(flags):
    strs = []

    if (flags & gpio.GPIO_PIN_INPUT):
        strs.append('INPUT')
    if (flags & gpio.GPIO_PIN_OUTPUT):
        strs.append('OUTPUT')
    if (flags & gpio.GPIO_PIN_OPENDRAIN):
        strs.append('OPENDRAIN')
    if (flags & gpio.GPIO_PIN_PUSHPULL):
        strs.append('PUSHPULL')
    if (flags & gpio.GPIO_PIN_TRISTATE):
        strs.append('TRISTATE')
    if (flags & gpio.GPIO_PIN_PULLUP):
        strs.append('PULLUP')
    if (flags & gpio.GPIO_PIN_PULLDOWN):
        strs.append('PULLDOWN')
    if (flags & gpio.GPIO_PIN_INVIN):
        strs.append('INVIN')
    if (flags & gpio.GPIO_PIN_INVOUT):
        strs.append('INVOUT')
    if (flags & gpio.GPIO_PIN_PULSATE):
        strs.append('PULSATE')

    return ','.join(strs)

gpioc = gpio.controller(0)
max_pin = gpioc.max_pin

print "Max pin #: %d" % max_pin

# Dump information about all known pins
for p in range(0, max_pin + 1):
    pin = gpioc.pin(p)
    try:
        value = pin.value
    except gpio.GpioError as e:
        # pin with this number is unknown
        continue

    caps = flags2str(pin.caps)
    config = flags2str(pin.config)

    name = pin.name

    print "#%3d: %s, value=%d, config=<%s>, caps=<%s>" % (p, name, value, config, caps)

# blink LED several times
led_pin = gpioc.pin(16)
for i in range(100):
    led_pin.toggle()
    sleep(0.05)
