import os
import _bsdgpio

GPIO_PIN_INPUT		= 0x0001
GPIO_PIN_OUTPUT		= 0x0002
GPIO_PIN_OPENDRAIN	= 0x0004
GPIO_PIN_PUSHPULL	= 0x0008
GPIO_PIN_TRISTATE	= 0x0010
GPIO_PIN_PULLUP		= 0x0020
GPIO_PIN_PULLDOWN	= 0x0040
GPIO_PIN_INVIN		= 0x0080
GPIO_PIN_INVOUT		= 0x0100
GPIO_PIN_PULSATE	= 0x0200

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
    def __init__ (self, unit = 0):
        self._fd =  os.open("/dev/gpioc%d" % unit, os.O_RDONLY)

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

def controller (unit):
    return GpioController(unit)

if __name__ == "__main__":
    pass
