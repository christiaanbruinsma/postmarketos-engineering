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

### GNOME Mobile GTK4 renderer workaround

GNOME Mobile is operational on the tested device, but accelerated GTK4 rendering can trigger repeated Panfrost `INSTR_INVALID_ENC` job-slot faults and visible frame corruption while scrolling.

Touch input was ruled out as the source of the apparent pointer/touch offset: the display is `720x1280` and the touchscreen reports exact matching absolute coordinate ranges of X `0..719` and Y `0..1279`.

A controlled GNOME Settings A/B test showed:

- normal renderer: `+221` Panfrost faults during approximately 10 seconds of scrolling, with visible flicker;
- forced Cairo renderer: `+0` faults during the equivalent scroll test, with smooth and correct rendering;
- forced `gl` renderer: severe visual corruption and therefore not retained.

The current per-user workaround is:

```text
GSK_RENDERER=cairo
```

Persisted in:

```text
~/.config/environment.d/90-gsk-renderer.conf
```

See [../../learnings/gtk4-panfrost-cairo-renderer-workaround.md](../../learnings/gtk4-panfrost-cairo-renderer-workaround.md).

## Validation status

The touchscreen fix has passed:

- package/kernel build;
- generated DTB audit;
- runtime enumeration on the intended physical controller;
- physical touchscreen operation;
- full reboot and repeat touchscreen operation.

The Cairo renderer workaround has passed an in-session runtime A/B test. Persistence across a later cold boot remains to be validated separately.

## Roadmap / deferred investigation

The following items are intentionally deferred and should be investigated without disturbing the currently stable touchscreen and renderer baselines:

- verify `GSK_RENDERER=cairo` persistence after a later cold boot;
- investigate autorotation through `iio-sensor-proxy` and kernel-exposed IIO devices;
- investigate the separate GNOME SensorDaemon failure caused by the absence of a udev backlight device;
- investigate why the runtime display stack falls back to `simpledrm` while native Exynos DRM drivers are compiled but no active DECON/DSI display nodes are present in the current Device Tree;
- isolate the exact Mesa/Panfrost/Midgard cause of the `INSTR_INVALID_ENC` accelerated-rendering faults;
- investigate the observed GDM logout/relogin wedge separately from the working boot-to-login path.

Do not change the known-working touchscreen I2C placement, kernel, DTB, or boot image as part of the deferred UI/sensor investigations unless new evidence specifically requires it.

The retained evidence is specific to the documented device/software baseline.
