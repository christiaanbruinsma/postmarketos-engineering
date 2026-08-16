# Changelog

## 0.2.0 - 2026-08-16

Hardware-proven Samsung Galaxy J5 (2017) native display baseline.

- Added the complete Exynos7870 native display patch series and MIPI PHY backport.
- Added the exact `linux-postmarketos-exynos7870` 6.15-r11 APKBUILD and reproducible config snapshot.
- Documented the r9 DSIM `-ENOENT` root cause and patch 17 clock-frequency fix.
- Documented the r10 DECON lifecycle root cause and minimal patch 18 fix.
- Added frozen r10/r11 runtime and DECON MMIO evidence with byte-exact hashes.
- Promoted the native display status from build-proven to hardware-proven.
- Recorded active 720x1280 scanout, advancing DECON IRQ/line counter, and absence of DRM timeout signatures.
- Recorded a successful normal reboot with display, GNOME Mobile login, and touch restored.
- Kept touchscreen evidence and native-display evidence as separate device fixes.
- Preserved binary/flash artifacts outside the public repository.
- Left CMA allocation pressure and unrelated boot warnings as separate evidence-first investigations.

## 0.1.0 - 2026-08-14

Initial public engineering baseline.

- Added evidence and promotion model.
- Added reproducible pmaports/device-development configuration guidance.
- Added public evidence hygiene and boot/rollback safety standards.
- Added Samsung Galaxy J5 (2017) `j5y17lte` device dossier.
- Added the runtime- and reboot-proven touchscreen I2C bus fix.
- Added reusable learning for Device Tree I2C bus mismatch diagnosis.
- Added evidence-first hardware debugging candidate pattern.
- Added GTK4/Panfrost renderer-isolation evidence from GNOME Mobile testing on Mali-T830.
- Added the device-specific `GSK_RENDERER=cairo` workaround after a controlled normal/Cairo/GL A/B test.
- Added deferred roadmap items for autorotation/IIO sensors, SensorDaemon/backlight, native Exynos display bring-up, GDM relogin behavior, and deeper Panfrost fault isolation.
- Added templates for future device fixes and learnings.
