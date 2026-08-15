# Native Exynos7870 display bring-up

## Status

**Build-proven, not hardware-proven. Nothing from this display stack has been flashed yet.**

Tested baseline:

- Device: Samsung Galaxy J5 (2017), SM-J530F, `j5y17lte`
- SoC: Samsung Exynos 7870
- Architecture: aarch64
- postmarketOS: v26.06
- Kernel package: `linux-postmarketos-exynos7870` 6.15, integrated locally as `pkgrel=8`
- UI target: GNOME Mobile

The goal is to replace the firmware/simple-framebuffer display path with the native Linux display stack:

```text
Exynos7870 DECON
→ Samsung DSIM / MIPI DSI
→ Samsung S6E8AA5X01
→ AMS520KT10
→ DRM panel
```

## Hardware identity proven from Samsung downstream sources

The SM-J530F/J5Y17 panel is Samsung **AMS520KT10** using the **S6E8AA5X01** controller.

Proven panel characteristics:

- 720 × 1280
- 60 Hz
- 65 × 115 mm physical size
- 4 MIPI DSI data lanes
- RGB888
- video mode
- burst mode
- `MIPI_DSI_MODE_VIDEO_NO_HFP`
- reset: `gpd3[4]`, active-low
- LCD 3.0 V rail: S2MPU05 LDO29
- LCD 1.8 V rail: S2MPU05 LDO30

Proven timings:

```text
HFP 130
HSW 20
HBP 60
VFP 14
VSW 2
VBP 8
```

Resulting mode totals are 930 × 1304 with a calculated 60 Hz timing clock of 72.7632 MHz.

## Proven power and reset lifecycle

Power on:

```text
LCD_3P0 on
LCD_1P8 on
wait 5–6 ms
reset physical HIGH
wait 5–6 ms
reset physical LOW
wait 5–6 ms
reset physical HIGH
wait 10–11 ms
```

Power off:

```text
reset physical LOW
wait 10–11 ms
LCD_1P8 off
LCD_3P0 off
```

The DRM driver therefore uses the two regulators sequentially rather than `regulator_bulk_enable()` / `regulator_bulk_disable()`.

## Proven minimal panel command sequence

The first bring-up driver intentionally contains only commands proven for J5Y17/AMS520KT10:

```text
F0 5A 5A       test key on
11             sleep out
wait 20 ms
F0 5A 5A       test key on again, matching downstream sequence
C0 D8 D8 40    Pentile
B0 06          DE-DIM global parameter
B8 A8          DE-DIM
CC 4C          PCD
E7 ED C7 23 67 ERRFLAG
wait 120 ms
F0 A5 A5       test key off
29             display on
```

Disable:

```text
28             display off
10             sleep in
wait 120 ms
```

The following are deliberately **not** guessed or copied from the AMS561RA01 reference driver:

- AMS561RA01 LTPS sequence
- DISPCTL data
- J5Y17 KOR-only LTPS data
- gamma tables
- AID/AOR tables
- MTP-derived calibration
- ELVSS calibration
- ACL policy
- HBM data
- fake/simple DCS brightness control

Samsung downstream proves that brightness is a calibration pipeline involving gamma, AID, temperature, ELVSS, ACL and gamma-update programming. The initial native driver therefore does not expose a fake `backlight_device`.

## Patch stack

The integrated display series consists of DSIM prerequisites, Exynos7870 DSIM/DRM support, SoC display DT, the Linux 6.15-adapted S6E8AA5X01 reference driver, the new AMS520KT10 panel driver, and J5 panel DT wiring.

See [PATCH-MANIFEST.md](PATCH-MANIFEST.md) for the exact active patch list and SHA-256 hashes.

## Validation completed

The following gates passed before any hardware runtime test:

- all DSIM prerequisite patches strict-applied in temporary fixtures with zero fuzz;
- AMS520KT10 driver compiled directly against Linux 6.15;
- integrated Kbuild for the new panel driver passed;
- patch #15 strict dry-run with `--fuzz=0` passed;
- patch #15 strict apply passed and produced byte-identical target files;
- patch #16 strict dry-run with `--fuzz=0` passed;
- patch #16 strict apply passed and produced the expected DTS exactly;
- J5 DTS preprocessing passed;
- DTB compilation passed;
- the only observed `dtc` warning concerns the pre-existing #13 DSI graph having a single `port@0` child while retaining address/size cells;
- postmarketOS package checksums regenerated successfully;
- full aarch64 `pmbootstrap build --force linux-postmarketos-exynos7870` completed successfully.

## Current boundary

The work is now **compile-proven for the real postmarketOS aarch64 kernel package**, but not yet runtime-proven on the phone.

Still unknown until a controlled hardware test:

- whether DECON and DSIM bind and link up correctly at runtime;
- whether the AMS520KT10 produces visible image without the proprietary Samsung luminance/calibration pipeline;
- whether additional panel calibration work is required before brightness can be exposed safely to userspace;
- whether GNOME Mobile can ultimately control brightness through a native backlight interface.

## Safety

The known-working touchscreen patch remains separate and unchanged. Its SHA-256 is recorded in the patch manifest.

Do not interpret a successful kernel build as permission to flash automatically. Flashing and first hardware validation must remain a separate, controlled step with a recovery path.