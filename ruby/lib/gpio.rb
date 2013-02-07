class GpioPin
  def initialize(controller,  pinno)
    @controller = controller
    @pinno = pinn0
  end
end

class GpioController
  def initialize(dev)
    @device_name = dev
  end

  def pin(pinno)
    return GpioPin(self, pinno)
  end

  def max_pin
    return 99
  end
end
