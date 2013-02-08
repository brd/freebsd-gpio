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
