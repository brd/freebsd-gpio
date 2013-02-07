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
        { NULL, 0 } };
	const struct iv_s *value_for_iv = values_for_iv;
        while (value_for_iv->name) {
	    constant_add_symbol(aTHX_  symbol_table, value_for_iv->name,
				strlen(value_for_iv->name), newSViv(value_for_iv->value));
            ++value_for_iv;
	}
  }
