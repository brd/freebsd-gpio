#!/usr/bin/env ruby19

require 'gpio'

gpioc = GpioController.new("/dev/gpioc0")
puts "Max pin #: #{gpioc.max_pin}"
