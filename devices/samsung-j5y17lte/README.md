# Samsung Galaxy J5 (2017) - j5y17lte

## Device identity

- Model: Samsung Galaxy J5 (2017) `SM-J530F`
- postmarketOS codename: `j5y17lte`
- SoC family: Samsung Exynos 7870

## Retained fixes

### Touchscreen I2C controller mismatch

The Imagis IST3038H touchscreen was described under the wrong physical I2C
controller in the tested mainline Device Tree.

The validated fix moves the touchscreen node from mainline `i2c2` to `i2c6`,
matching the physical controller at `0x13890000` used by the vendor Device Tree.

See [fixes/touchscreen-i2c6/](fixes/touchscreen-i2c6/).

### Native Exynos7870 display

The device now has a hardware-proven native display path:

```text
Exynos DRM
-> DECON
-> Samsung DSIM / MIPI DSI
-> S6E8AA5X01 / AMS520KT10
-> 720x1280 AMOLED
```

The retained baseline uses `linux-postmarketos-exynos7870` 6.15-r11,
runtime `#12-postmarketOS`.

Validation includes:

- physical display output;
- GNOME Mobile login and desktop;
- working touch on the same baseline;
- advancing DECON IRQ and line counter;
- programmed timing/scanout MMIO;
- no DRM vblank/flip/commit timeout signature;
- zero failed systemd units;
- normal reboot with display and touch returning.

See [fixes/native-display/](fixes/native-display/).

### GNOME Mobile GTK4 renderer workaround

GNOME Mobile is operational, but accelerated GTK4 rendering can trigger repeated
Panfrost `INSTR_INVALID_ENC` job-slot faults and visible frame corruption while
scrolling.

A controlled GNOME Settings A/B test showed:

- normal renderer: `+221` Panfrost faults during approximately 10 seconds of scrolling;
- forced Cairo renderer: `+0` faults during the equivalent scroll test;
- forced `gl` renderer: severe visual corruption.

The retained per-user workaround is:

```text
GSK_RENDERER=cairo
```

See [../../learnings/gtk4-panfrost-cairo-renderer-workaround.md](../../learnings/gtk4-panfrost-cairo-renderer-workaround.md).

## Validation status

The touchscreen and native-display fixes have both passed runtime hardware and
normal reboot gates. They remain separate dossiers so future changes can be
reasoned about independently.

## Roadmap / deferred investigation

Investigate without disturbing the known-good touchscreen/native-display baseline:

- CMA allocation pressure observed under GNOME Mobile;
- autorotation through `iio-sensor-proxy` and kernel IIO devices;
- the separate GNOME SensorDaemon/backlight issue;
- the exact Mesa/Panfrost/Midgard cause of `INSTR_INVALID_ENC`;
- GDM logout/relogin behavior.

Do not change the known-working display patch stack, touchscreen I2C placement,
kernel inputs, DTB, or boot image merely to silence unrelated warnings.
