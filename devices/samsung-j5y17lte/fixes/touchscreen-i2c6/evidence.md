# Touchscreen I2C6 Evidence

## Evidence boundary

This dossier records the evidence that established the `j5y17lte` touchscreen bus mismatch and validated the minimal Device Tree fix.

Public documentation intentionally omits local usernames, hostnames, absolute private filesystem paths, and raw boot images.

## 1. Failure mode

Before the fix, the Imagis driver could not communicate with the touchscreen while the peripheral was attached to mainline `i2c2`.

Observed failure class:

```text
imagis_i2c_read_reg - i2c_transfer failed: -6
chip ID read failure: -6
```

`-6` is consistent with no responding device at the attempted I2C address/bus boundary.

## 2. Hardware-controller evidence

The vendor Device Tree for the same device places the touchscreen on:

```text
i2c@13890000
```

The corresponding mainline Exynos7870 controller is `i2c6`.

The final runtime device path included:

```text
13890000.i2c
```

This identifies the physical SoC controller. The dynamically assigned runtime path also contained `i2c-2` / `2-0050`; that adapter number does **not** mean the device is physically attached to mainline `i2c2`.

## 3. Retained patch identity

File:

```text
j5y17lte-touchscreen-i2c6.patch.manual
```

SHA-256:

```text
e35bade7efaac59a8a4626316f3263f95dfe01b20fd0940ae1e6f556095cb02b
```

SHA-512:

```text
8c7002af4a23858c1587f1706282c374b401099d965540a07157639d421b24e466f1d3974dd223abed06464065916ede28b154ea0dca8fba166922272d6a1552
```

Patch scope:

```diff
-&i2c2 {
+&i2c6 {
```

Curated pmaports package diff SHA-256:

```text
084907645553162990667336f3bbdf01421dd2a363f5bc9c438c6b4b0ef837c4
```

The curated diff was reconstructed from the validated final `APKBUILD` plus the documented baseline delta. It intentionally omits `git format-patch` author/mail metadata; the original local pmaports commit remains the Git-history source of truth.

No driver or regulator change is part of the retained patch.

## 4. Final pmaports development state

Development baseline:

```text
9e1f56d217
```

Local fix commit:

```text
f221f69983
```

Commit subject:

```text
linux-postmarketos-exynos7870: fix j5y17lte touchscreen I2C bus
```

Package state:

```text
pkgver=6.15
pkgrel=7
source commit=5686e3b545bd34e80ec6e73604b8819d10e52a2c
```

Validated `APKBUILD` SHA-256:

```text
ad3cf5d0f2e769552d5c6f524a42c20585dbbb9398face31f6df905697a0687d
```

The uploaded kernel configuration used alongside this package was independently retained during repository preparation with SHA-256:

```text
8300b0fdfe87278dd58a6ceeaa013f4a951395729f05ed2bcc4131a9857d9924
```

It is intentionally not committed here because the touchscreen fix does not require a kernel-config change and the complete configuration adds no necessary evidence to the public fix dossier.

## 5. Build gate

The final package was built while explicitly targeting the intended pmaports worktree.

Command form:

```bash
pmbootstrap -p /path/to/pmaports-worktree \
  build --arch aarch64 --force linux-postmarketos-exynos7870
```

Result:

```text
edge/linux-postmarketos-exynos7870: Done!
Finished building packages
DONE!
```

Built package:

```text
linux-postmarketos-exynos7870-6.15-r7.apk
```

SHA-256:

```text
902ee6af2e9aaaf748cba63fcd9443d670b009b84f18d68fc15e464720cb7de0
```

## 6. Generated DTB gate

Built DTB:

```text
boot/dtbs/exynos/exynos7870-j5y17lte.dtb
```

SHA-256:

```text
e243e774eb5a0ac1bb2fa95f2d40dfabac79840fc0eb7e5c7a0914d336cde67d
```

Decompiled built-DTB evidence established:

```text
i2c@13850000
    status = "disabled"
```

with no touchscreen node there, while:

```text
i2c@13890000
    status = "okay"

    touchscreen@50 {
        compatible = "imagis,ist3038h";
        ...
    };
```

was present under the intended controller.

This proves that the packaged generated Device Tree contained the intended bus move.

## 7. Module isolation gate

The control and test kernel packages each contained 292 kernel modules.

After path/version normalization, complete SHA-256 manifests compared with no differences:

```text
292 / 292 kernel modules byte-identical
```

The touchscreen module specifically remained byte-identical:

```text
imagis.ko.zst
SHA-256 d5f2038560d2574c345c3506d24e99ef5aa720d08c86e33a2ae3a24b0930c5f4
```

This supports the conclusion that the functional change was not caused by a modified Imagis kernel module.

## 8. Runtime gate

After flashing the test image, runtime enumeration included:

```text
input: Imagis capacitive touchscreen as /devices/platform/soc@0/13890000.i2c/i2c-2/2-0050/input/input2
```

Input identity:

```text
N: Name="Imagis capacitive touchscreen"
H: Handlers=event2
```

Physical touchscreen interaction worked.

## 9. Reboot gate

After a complete reboot, touchscreen operation worked again.

Therefore the result passed both initial runtime and post-reboot functional validation.

## 10. Rollback / flash-integrity evidence

An original boot-partition rollback image was retained outside Git.

Original boot image:

```text
size: 32 MiB
SHA-256: 517d959df610d4a7b93ba64106088b440459d0f161106345df18d67f2434f1d1
```

Working I2C6 test image:

```text
size: 33,396,736 bytes
SHA-256: b308f489b59c4fc76cf0ff031c6cfd9cd38b236b6ebcea99a61b988d28c58ec5
```

Physical BOOT partition capacity recorded during validation:

```text
33,554,432 bytes
```

The candidate image therefore fit within the partition.

A post-flash readback of the written image length produced the same SHA-256:

```text
b308f489b59c4fc76cf0ff031c6cfd9cd38b236b6ebcea99a61b988d28c58ec5
```

This proves byte-exact flash/readback identity for the tested range; functional boot and touchscreen operation were validated separately.

## 11. Final patch gate

```text
git diff --check        PASS
APKBUILD shell syntax   PASS
full kernel build       PASS
built DTB audit         PASS
runtime hardware test   PASS
post-reboot touch       PASS
unrelated files         0
working tree            clean after local commit
```

## 12. Known non-cause

The runtime warning:

```text
imagis-touchscreen 2-0050: supply vddio not found, using dummy regulator
```

remained while the touchscreen functioned correctly.

Within this evidence boundary, it was not causal to the touchscreen failure and is intentionally left unchanged.

## 13. Upstream state

At evidence capture time, the final fix commit existed only in the local pmaports worktree and had not been pushed to postmarketOS upstream.
