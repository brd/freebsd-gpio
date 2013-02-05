#!/usr/bin/env python

from distutils.core import setup, Extension

gpio = Extension('gpio',
                    sources = ['gpiomodule.c'])

setup (name = 'gpio',
       version = '1.0',
       description = 'FreeBSD GPIO access wrapper',
       ext_modules = [gpio])
