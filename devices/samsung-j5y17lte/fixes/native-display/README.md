# Native Exynos7870 display bring-up

## Status

**Hardware-proven stable baseline - Panel 19.24 / r11.**

Tested baseline:

- Device: Samsung Galaxy J5 (2017), SM-J530F, `j5y17lte`
- SoC: Samsung Exynos 7870
- Architecture: aarch64
- postmarketOS: v26.06
- Kernel package: `linux-postmarketos-exynos7870` 6.15-r11
- Runtime: `6.15.0-exynos7870 #12-postmarketOS`
- UI: GNOME Mobile

Working native chain:

```text
Exynos DRM
-> DECON
-> Samsung DSIM / MIPI DSI
-> Samsung S6E8AA5X01
-> AMS520KT10
-> physical AMOLED
```

The baseline passed physical display output, GNOME Mobile login/desktop, touch,
runtime IRQ/MMIO proof, absence of DRM timeout signatures, and a normal reboot.

## Hardware identity

The SM-J530F/J5Y17 panel is Samsung **AMS520KT10** using the
**S6E8AA5X01** controller.

Proven panel characteristics:

- 720 x 1280
- 60 Hz
- 65 x 115 mm
- 4 MIPI DSI data lanes
- RGB888
- video mode
- burst mode
- `MIPI_DSI_MODE_VIDEO_NO_HFP`
- reset `gpd3[4]`, active-low
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

Mode totals are 930 x 1304 with a calculated 60 Hz timing clock of 72.7632 MHz.

## Power and reset lifecycle

Power on:

```text
LCD_3P0 on
LCD_1P8 on
wait 5-6 ms
reset physical HIGH
wait 5-6 ms
reset physical LOW
wait 5-6 ms
reset physical HIGH
wait 10-11 ms
```

Power off:

```text
reset physical LOW
wait 10-11 ms
LCD_1P8 off
LCD_3P0 off
```

The panel driver therefore enables/disables the two rails sequentially.

## Minimal panel sequence

The retained driver intentionally uses only the sequence proven for
J5Y17/AMS520KT10:

```text
F0 5A 5A
11
wait 20 ms
F0 5A 5A
C0 D8 D8 40
B0 06
B8 A8
CC 4C
E7 ED C7 23 67
wait 120 ms
F0 A5 A5
29
```

Disable:

```text
28
10
wait 120 ms
```

The following are deliberately not guessed or copied from the AMS561RA01
reference implementation:

- AMS561RA01 LTPS sequence
- DISPCTL data
- J5Y17 KOR-only LTPS data
- gamma tables
- AID/AOR tables
- MTP calibration
- ELVSS calibration
- ACL policy
- HBM data
- fake DCS brightness control

Brightness remains a separate calibration problem and is not faked by this
bring-up driver.

## Reproducible source

- [`PATCH-MANIFEST.md`](PATCH-MANIFEST.md) records the exact patch order and critical hashes.
- [`pmaports/APKBUILD`](pmaports/APKBUILD) is the exact r11 kernel package recipe.
- [`SOURCE-SHA256SUMS`](SOURCE-SHA256SUMS) records original source/evidence hashes.
- [`STORED-SHA256SUMS`](STORED-SHA256SUMS) records repository-storage hashes.
- [`materialize.sh`](materialize.sh) restores compressed large inputs byte-exact.
- [`evidence.md`](evidence.md) documents the r9 -> r10 -> r11 diagnosis and hardware proof.

The known-working touchscreen patch remains in the sibling
[`touchscreen-i2c6`](../touchscreen-i2c6/) fix and is not duplicated here.

## Current engineering boundary

Native display output is proven stable. Remaining work must be investigated
without changing this baseline unless new evidence requires it.

In particular:

- do not shotgun-fix unrelated boot warnings;
- do not invent a simple backlight interface without panel calibration evidence;
- investigate observed CMA allocation pressure separately;
- preserve the r11 source/hashes before any future display-stack experiment.
