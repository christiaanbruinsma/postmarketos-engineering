# j5y17lte Touchscreen I2C Controller Fix

## Status

**Runtime and post-reboot validated.**

At the time this evidence was captured, the fix existed as a local pmaports commit and had **not** been pushed to postmarketOS upstream.

## Scope

- Device: Samsung Galaxy J5 (2017), `SM-J530F`
- Codename: `j5y17lte`
- Touchscreen: Imagis IST3038H
- Kernel package: `linux-postmarketos-exynos7870`
- Kernel version in tested v26.06 runtime: `6.15.0-exynos7870`
- Current pmaports development baseline used for the final build audit: `9e1f56d217`
- Local fix commit: `f221f69983`
- Final development package state: `6.15-r7`

## Symptom

The touchscreen driver attempted I2C communication but failed with `-6` (`ENXIO`) while the touchscreen was described under mainline `&i2c2`.

The failure was not solved by changing the driver or regulator configuration.

## Root cause

The original Device Tree placed `touchscreen@50` under:

```dts
&i2c2 {
```

The relevant runtime physical controller is:

```text
13890000.i2c
```

The Samsung vendor Device Tree uses controller `i2c@13890000` for this touchscreen. On the mainline Exynos7870 Device Tree this controller is represented by `i2c6`.

Therefore the minimal fix is:

```diff
-&i2c2 {
+&i2c6 {
```

The complete retained patch is [j5y17lte-touchscreen-i2c6.patch.manual](j5y17lte-touchscreen-i2c6.patch.manual). A curated package-level representation of the same pmaports change is retained as [pmaports-main.diff](pmaports-main.diff). It contains no Git mail/author metadata and is not a replacement for the original pmaports commit history.

## Why `.patch.manual`

The Exynos7870 package copies external Device Tree sources into the kernel tree during `prepare()`.

A normal Alpine package `.patch` can be applied by `default_prepare()` before those external DTS files exist in the kernel tree. The touchscreen patch is therefore retained as `.patch.manual` and applied explicitly after the external devicetrees have been copied:

```sh
# The external devicetrees are copied above, so apply this afterwards.
patch -p1 < "$srcdir/j5y17lte-touchscreen-i2c6.patch.manual"
```

This is a package-flow decision, not a general requirement for Device Tree patches.

## Final APKBUILD delta

The validated development package changed the package release from `6` to `7`, added the manual patch to `source`, applied it at the end of the relevant `prepare()` stage, and added its SHA-512 checksum.

Relevant final state:

```text
pkgver=6.15
pkgrel=7
source commit=5686e3b545bd34e80ec6e73604b8819d10e52a2c
```

Patch SHA-512 used by `APKBUILD`:

```text
8c7002af4a23858c1587f1706282c374b401099d965540a07157639d421b24e466f1d3974dd223abed06464065916ede28b154ea0dca8fba166922272d6a1552
```

## Known non-cause

The runtime warning below remained present after the touchscreen became fully functional:

```text
supply vddio not found, using dummy regulator
```

Within this evidence boundary it was **not** the cause of the non-working touchscreen. Do not modify `vddio`, regulator definitions, or the Imagis driver solely to remove this warning without new failure evidence.

## Upstream boundary

The local pmaports commit retained for provenance is:

```text
f221f69983  linux-postmarketos-exynos7870: fix j5y17lte touchscreen I2C bus
```

This knowledge repository does not import or rewrite pmaports Git history. The exact device patch and its evidence are retained here, while the original pmaports worktree/commit remains a separate local source-history artifact until explicitly cleaned up.
