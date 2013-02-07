#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <sys/gpio.h>

struct iv_s {
    const char *name;
    IV value;
};

static void
constant_add_symbol(pTHX_  HV *hash, const char *name, I32 namelen, SV *value) 
{
    HE *he = (HE*) hv_common_key_len(hash, name, namelen, HV_FETCH_LVALUE, NULL, 0);
    SV *sv;

    if (!he) {
        Perl_croak(aTHX_  "Couldn't add key '%s' to %%GPIO::",
                   name);
    }
    sv = HeVAL(he);
    if (SvOK(sv) || SvTYPE(sv) == SVt_PVGV) {
        /* Someone has been here before us - have to make a real sub.  */
        newCONSTSUB(hash, name, value);
    } else {
        SvUPGRADE(sv, SVt_RV);
        SvRV_set(sv, value);
        SvROK_on(sv);
        SvREADONLY_on(value);
    }
}

MODULE = GPIO               PACKAGE = GPIO

BOOT:
  {
#ifdef dTHX
    dTHX;
#endif
    HV *symbol_table = get_hv("GPIO::", GV_ADD);

    static const struct iv_s values_for_iv[] =
      {
        { "PIN_INPUT", GPIO_PIN_INPUT },
        { "PIN_OUTPUT", GPIO_PIN_OUTPUT },
        { "PIN_OPENDRAIN", GPIO_PIN_OPENDRAIN },
        { "PIN_PUSHPULL", GPIO_PIN_PUSHPULL },
        { "PIN_TRISTATE", GPIO_PIN_TRISTATE },
        { "PIN_PULLUP", GPIO_PIN_PULLUP },
        { "PIN_PULLDOWN", GPIO_PIN_PULLDOWN },
        { "PIN_INVIN", GPIO_PIN_INVIN },
        { "PIN_INVOUT", GPIO_PIN_INVOUT },
        { "PIN_PULSATE", GPIO_PIN_PULSATE },
        { "HIGH", GPIO_PIN_HIGH },
        { "LOW", GPIO_PIN_LOW },
        { NULL, 0 } };
	const struct iv_s *value_for_iv = values_for_iv;
        while (value_for_iv->name) {
	    constant_add_symbol(aTHX_  symbol_table, value_for_iv->name,
				strlen(value_for_iv->name), newSViv(value_for_iv->value));
            ++value_for_iv;
	}
  }

SV*
_get_max_pin(fd)
    int fd;
INIT:
    int err, maxpin;
    maxpin = 0;
CODE:
    err = ioctl(fd, GPIOMAXPIN, &maxpin);
    if (err < 0) {
        croak("ioctl(GPIOMAXPIN) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    }
    else
        RETVAL = newSViv(maxpin);
OUTPUT:
    RETVAL

SV*
_is_pin_valid(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0)
        RETVAL = &PL_sv_no;
    else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_get_pin_name(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSVpv(pin.gp_name, 0);
OUTPUT:
    RETVAL

SV*
_get_pin_caps(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(pin.gp_caps);
OUTPUT:
    RETVAL

SV*
_get_pin_config(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(pin.gp_flags);
OUTPUT:
    RETVAL

SV*
_set_pin_config(fd, pinno, config)
    int fd;
    int pinno;
    int config;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    pin.gp_flags = config;
    err = ioctl(fd, GPIOSETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOSETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_no;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_get_pin_value(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    err = ioctl(fd, GPIOGET, &req);
    if (err < 0) {
        croak("ioctl(GPIOGET) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(req.gp_value);
OUTPUT:
    RETVAL

SV*
_set_pin_value(fd, pinno, value)
    int fd;
    int pinno;
    int value;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    req.gp_value = value ? 1 : 0;
    err = ioctl(fd, GPIOSET, &req);
    if (err < 0) {
        croak("ioctl(GPIOSET) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_no;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_toggle_pin_value(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    err = ioctl(fd, GPIOTOGGLE, &req);
    if (err < 0) {
        croak("ioctl(GPIOTOGGLE) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL
