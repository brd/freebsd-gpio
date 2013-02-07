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

#include <Python.h>

#include <stdio.h>
#include <sys/gpio.h>

static PyObject *GpioError;

static PyObject *
_bsdgpio_get_max_pin(PyObject *self, PyObject *args)
{
    int fd, err, maxpin;

    if (!PyArg_ParseTuple(args, "i", &fd))
        return NULL;

    maxpin = 0;
    err = ioctl(fd, GPIOMAXPIN, &maxpin);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    return Py_BuildValue("i", maxpin);
}



static PyObject *
_bsdgpio_get_value(PyObject *self, PyObject *args)
{
    int fd, pinno, err;
    struct gpio_req req;

    if (!PyArg_ParseTuple(args, "ii", &fd, &pinno))
        return NULL;

    req.gp_pin = pinno;
    err = ioctl(fd, GPIOGET, &req);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    return Py_BuildValue("i", req.gp_value);
}

static PyObject *
_bsdgpio_set_value(PyObject *self, PyObject *args)
{
    int fd, pinno, val, err;
    struct gpio_req req;

    if (!PyArg_ParseTuple(args, "iii", &fd, &pinno, &val))
        return NULL;

    req.gp_pin = pinno;
    req.gp_value = val;
    err = ioctl(fd, GPIOSET, &req);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    Py_RETURN_NONE;
}

static PyObject *
_bsdgpio_toggle_value(PyObject *self, PyObject *args)
{
    int fd, pinno, err;
    struct gpio_req req;

    if (!PyArg_ParseTuple(args, "ii", &fd, &pinno))
        return NULL;

    req.gp_pin = pinno;
    err = ioctl(fd, GPIOTOGGLE, &req);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    Py_RETURN_NONE;
}

static PyObject *
_bsdgpio_get_config(PyObject *self, PyObject *args)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    if (!PyArg_ParseTuple(args, "ii", &fd, &pinno))
        return NULL;

    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    return Py_BuildValue("i", pin.gp_flags);
}

static PyObject *
_bsdgpio_set_config(PyObject *self, PyObject *args)
{
    int fd, pinno, flags, err;
    struct gpio_pin pin;

    if (!PyArg_ParseTuple(args, "iii", &fd, &pinno, &flags))
        return NULL;

    pin.gp_pin = pinno;
    pin.gp_flags = flags;
    err = ioctl(fd, GPIOSETCONFIG, &pin);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    Py_RETURN_NONE;
}

static PyObject *
_bsdgpio_get_caps(PyObject *self, PyObject *args)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    if (!PyArg_ParseTuple(args, "ii", &fd, &pinno))
        return NULL;

    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    return Py_BuildValue("i", pin.gp_caps);
}

static PyObject *
_bsdgpio_get_name(PyObject *self, PyObject *args)
{
    int fd, pinno, err;
    struct gpio_pin pin;

    if (!PyArg_ParseTuple(args, "ii", &fd, &pinno))
        return NULL;

    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        PyErr_SetFromErrno(GpioError);
        return NULL;
    }

    return Py_BuildValue("s", pin.gp_name);
}

static PyMethodDef GpioMethods[] = {
    {"get_max_pin",  _bsdgpio_get_max_pin, METH_VARARGS, "Get maximum pin number."},
    {"get_value",  _bsdgpio_get_value, METH_VARARGS, "Get pin value."},
    {"set_value",  _bsdgpio_set_value, METH_VARARGS, "Set pin value."},
    {"toggle_value",  _bsdgpio_toggle_value, METH_VARARGS, "Toggle pin value."},
    {"get_config",  _bsdgpio_get_config, METH_VARARGS, "Get pin config."},
    {"set_config",  _bsdgpio_set_config, METH_VARARGS, "Set pin config."},
    {"get_caps",  _bsdgpio_get_caps, METH_VARARGS, "Get pin capabilities."},
    {"get_name",  _bsdgpio_get_name, METH_VARARGS, "Get pin name."},

    {NULL, NULL, 0, NULL}        /* Sentinel */
};

PyMODINIT_FUNC
init_bsdgpio(void)
{
    PyObject *m;

    m = Py_InitModule("_bsdgpio", GpioMethods);
    if (m == NULL)
        return;

    GpioError = PyErr_NewException("_bsdgpio.error", NULL, NULL);
    Py_INCREF(GpioError);
    PyModule_AddObject(m, "error", GpioError);
}
