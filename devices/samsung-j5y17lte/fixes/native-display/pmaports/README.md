# r11 pmaports package snapshots

`APKBUILD` is the exact `linux-postmarketos-exynos7870` 6.15-r11 package recipe
used for the hardware-proven native-display baseline.

`device/APKBUILD` and `device/deviceinfo` are the exact archived J5 device-package
inputs used alongside that kernel recipe. They preserve the dependency and
boot-image metadata of the validated build without implying an upstream
postmarketOS submission.

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
11867a8b61870ca18577bc9368efdf9e10af377c5be971ec8947e347c79c2594  config-postmarketos-exynos7870.aarch64
d9a98bb62d9ac7f7946ccb513f02b3fc5c5b7f31e50962025f9fefa1e01a5c9c  device/APKBUILD
db22721ed32308bc44f68dae3f6463bea3f6df8dc22b9b9dd3c2630c028e2826  device/deviceinfo
```

The APKBUILD also references `j5y17lte-touchscreen-i2c6.patch.manual`.
That already-proven fix is retained separately in
[`../../touchscreen-i2c6/`](../../touchscreen-i2c6/) and is intentionally not
duplicated in this native-display dossier.
