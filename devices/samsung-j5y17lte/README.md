# Samsung Galaxy J5 (2017) - j5y17lte

## Device identity

- Model: Samsung Galaxy J5 (2017) `SM-J530F`
- postmarketOS codename: `j5y17lte`
- SoC family: Samsung Exynos 7870

## Retained fixes

### Touchscreen I2C controller mismatch

The Imagis IST3038H touchscreen was described under the wrong physical I2C controller in the mainline Device Tree used by the tested postmarketOS kernel package.

The validated fix moves the touchscreen node from mainline `i2c2` to `i2c6`, matching the physical controller at `0x13890000` used by the vendor Device Tree.

See [fixes/touchscreen-i2c6/](fixes/touchscreen-i2c6/).

## Validation status

The touchscreen fix has passed:

- package/kernel build;
- generated DTB audit;
- runtime enumeration on the intended physical controller;
- physical touchscreen operation;
- full reboot and repeat touchscreen operation.

The retained evidence is specific to the documented device/software baseline.
