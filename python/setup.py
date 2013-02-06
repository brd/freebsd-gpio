#!/usr/bin/env python

from distutils.core import setup, Extension

bsd_ext = Extension('_bsdgpio',
                    sources = ['_bsdgpiomodule.c'])

setup (name = 'gpio',
       version = '1.0',
       description = 'FreeBSD GPIO access wrapper',
       ext_modules = [bsd_ext],
       py_modules = ['gpio']
       );
