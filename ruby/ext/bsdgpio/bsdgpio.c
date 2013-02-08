/*-
 * Copyright (c) 2013 Oleksandr Tymoshenko <gonzo@bluezbox.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#include <ruby.h>

#include <sys/gpio.h>

static VALUE bsdgpio_max_pin(VALUE self, VALUE rbFd)
{
    int fd, err, maxpin;

    fd = NUM2INT(rbFd);
    maxpin = 0;
    err = ioctl(fd, GPIOMAXPIN, &maxpin);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOMAXPIN) failed");
	return Qnil;
    }

    return INT2NUM(maxpin);
}

static VALUE bsdgpio_is_pin_valid(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    pin.gp_pin = pinno;

    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0)
        return Qfalse;
    else
        return Qtrue;
}

static VALUE bsdgpio_get_pin_name(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    pin.gp_pin = pinno;

    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOGETCONFIG) failed");
        return Qnil;
    }

    return rb_str_new2(pin.gp_name);
}

static VALUE bsdgpio_get_pin_caps(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    pin.gp_pin = pinno;

    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOGETCONFIG) failed");
        return Qnil;
    }

    return INT2NUM(pin.gp_caps);
}

static VALUE bsdgpio_get_pin_config(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    pin.gp_pin = pinno;

    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOGETCONFIG) failed");
        return Qnil;
    }

    return INT2NUM(pin.gp_flags);
}

static VALUE bsdgpio_set_pin_config(VALUE self, VALUE rbFd, VALUE rbPin,
    VALUE rbConfig)
{
    int fd, pinno, err, config;
    struct gpio_pin pin;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    config = NUM2INT(rbConfig);

    pin.gp_pin = pinno;
    pin.gp_flags = config;

    err = ioctl(fd, GPIOSETCONFIG, &pin);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOSETCONFIG) failed");
        return Qnil;
    }

    return Qnil;
}

static VALUE bsdgpio_get_pin_value(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_req req;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    req.gp_pin = pinno;

    err = ioctl(fd, GPIOGET, &req);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOGET) failed");
        return Qnil;
    }

    return INT2NUM(req.gp_value);
}

static VALUE bsdgpio_set_pin_value(VALUE self, VALUE rbFd, VALUE rbPin,
    VALUE rbValue)
{
    int fd, pinno, err, value;
    struct gpio_req req;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    value = NUM2INT(rbValue);

    req.gp_pin = pinno;
    req.gp_value = value;

    err = ioctl(fd, GPIOSET, &req);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOSET) failed");
        return Qnil;
    }

    return Qnil;
}

static VALUE bsdgpio_toggle_pin_value(VALUE self, VALUE rbFd, VALUE rbPin)
{
    int fd, pinno, err;
    struct gpio_req req;

    fd = NUM2INT(rbFd);
    pinno = NUM2INT(rbPin);
    req.gp_pin = pinno;

    err = ioctl(fd, GPIOTOGGLE, &req);
    if (err < 0) {
        rb_sys_fail("ioctl(GPIOTOGGLE) failed");
        return Qnil;
    }

    return Qnil;
}

/* ruby calls this to load the extension */
void Init_bsdgpio(void) {
    VALUE rb_mBsdGpio = rb_define_module("BsdGpio");

    rb_define_module_function(rb_mBsdGpio, "max_pin", bsdgpio_max_pin, 1);
    rb_define_module_function(rb_mBsdGpio, "is_pin_valid", bsdgpio_is_pin_valid, 2);
    rb_define_module_function(rb_mBsdGpio, "get_pin_name", bsdgpio_get_pin_name, 2);
    rb_define_module_function(rb_mBsdGpio, "get_pin_caps", bsdgpio_get_pin_caps, 2);
    rb_define_module_function(rb_mBsdGpio, "get_pin_value", bsdgpio_get_pin_value, 2);
    rb_define_module_function(rb_mBsdGpio, "set_pin_value", bsdgpio_set_pin_value, 3);
    rb_define_module_function(rb_mBsdGpio, "toggle_pin_value", bsdgpio_toggle_pin_value, 2);
    rb_define_module_function(rb_mBsdGpio, "get_pin_config", bsdgpio_get_pin_config, 2);
    rb_define_module_function(rb_mBsdGpio, "set_pin_config", bsdgpio_set_pin_config, 3);
}
