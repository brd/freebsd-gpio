freebsd-gpio
============

Simple wrappers around FreeBSD's GPIO ioctl for Per, Python, and Ruby

Perl
----

### Build
```
perl Makefile.PL
make
make install
```

### Example
```perl
use GPIO;

my $controller = GPIO->new();
$controller->open() or die("Can't open GPIO controller dev: $!");


# config pin
$controller->set_pin_config(16, GPIO::PIN_OUTPUT);

# pin LOW, LED is on
$controller->set_pin_value(16, GPIO::LOW);
sleep(1);

# pin HIGH, LED is on
$controller->set_pin_value(16, GPIO::HIGH);
```

Python
------

### Build
```
python setup.py build
python setup.py install
```

### Example
```python
from time import sleep
import gpio

gpioc = gpio.controller()

led_pin = gpioc.pin(16)
# config pin
led_pin.config = gpio.PIN_OUTPUT

# pin LOW, LED is on
led_pin.value = gpio.LOW
sleep(1);

# pin HIGH, LED is off
led_pin.value = gpio.HIGH
```

Ruby
----

### Build
```
gem build gpio.gemspec
gem install ./gpio-0.0.1.gem
```

### Example
```ruby
require 'gpio'

gpioc = GpioController.new("/dev/gpioc0")

led_pin = gpioc.pin(16)
# config pin
led_pin.config = GPIO_PIN_OUTPUT

# pin LOW, led is ON
led_pin.value = GPIO_LOW
sleep(1)

# pin HIGH, led is OFF
led_pin.value = GPIO_HIGH

```

Examples
--------

Each subdirectory contains demo script (rpi-gpio-demo) for 
Raspberry Pi written in respective language. It simply dumps
GPIO pins information to stdout and blinks activity LED for
some time
