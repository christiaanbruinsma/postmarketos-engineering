# r11 pmaports kernel package snapshot

`APKBUILD` is the exact `linux-postmarketos-exynos7870` 6.15-r11 package recipe
used for the hardware-proven native-display baseline.

The exact kernel config is stored as four ordered XZ segments:

```text
config-postmarketos-exynos7870.aarch64.xz.part-00
config-postmarketos-exynos7870.aarch64.xz.part-01
config-postmarketos-exynos7870.aarch64.xz.part-02
config-postmarketos-exynos7870.aarch64.xz.part-03
```

Run `../materialize.sh` from this dossier to reconstruct:

```text
config-postmarketos-exynos7870.aarch64
```

Expected SHA-256:

```text
11867a8b61870ca18577bc9368efdf9e10af377c5be971ec8947e347c79c2594
```

The APKBUILD also references `j5y17lte-touchscreen-i2c6.patch.manual`.
That already-proven fix is retained separately in
[`../../touchscreen-i2c6/`](../../touchscreen-i2c6/) and is intentionally not
duplicated in this native-display dossier.
