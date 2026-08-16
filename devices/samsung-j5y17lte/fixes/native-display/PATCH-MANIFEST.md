# Patch manifest - Samsung J5 2017 native Exynos display

This manifest describes the hardware-proven `j5y17lte` native display stack used by
`linux-postmarketos-exynos7870` 6.15-r11, runtime build `#12-postmarketOS`.

## Apply order

The active display inputs are:

1. `exynos7870-mipi-phy-v6.15-backport.patch.manual`
2. `01-link-dphy-status.patch.manual`
3. `02-sfrctrl.patch.manual`
4. `03-header-fifo.patch.manual`
5. `04-clkctrl-bits.patch.manual`
6. `05-main-vsa.patch.manual`
7. `06-video-mode-bit.patch.manual`
8. `07-pll-ms-offsets.patch.manual`
9. `08-pll-stable-bit.patch.manual`
10. `09-pll-stable-timeout.patch.manual`
11. `10-clk-data-v6.15.patch.manual`
12. `11-exynos7870-dsim.patch.manual`
13. `12-exynos7870-drm-glue.patch.manual`
14. `13-exynos7870-display-dt.patch.manual`
15. `14-s6e8aa5x01-panel-base-v6.15.patch.manual`
16. `15-ams520kt10-panel-v6.15.patch.manual`
17. `16-j5y17lte-native-panel-dt.patch.manual`
18. `17-j5y17lte-dsim-clock-frequencies.patch.manual`
19. `18-exynos7-decon-enable-lifecycle.patch.manual`

The package also applies the already retained touchscreen fix from the sibling
[`touchscreen-i2c6`](../touchscreen-i2c6/) dossier. It is intentionally not duplicated here.

## Storage and materialization

Patches 01-13 and 15-18, plus the MIPI PHY backport, are stored as plain text.
Patch 14 is stored as deterministic XZ because it is substantially larger. Run:

```sh
./materialize.sh
```

to reconstruct patch 14, the exact r11 kernel config, and frozen runtime evidence.
`SOURCE-SHA256SUMS` verifies the reconstructed original bytes.

## Critical r10 -> r11 fixes

### Patch 17 - DSIM input clock frequencies

`17-j5y17lte-dsim-clock-frequencies.patch.manual`

SHA-256:

```text
14b6505b51d5e9a15fcc21f20d524f47ffc56a163a572fdc92dc8ccc5259c11d
```

It provides the clock frequencies required by the Linux 6.15 Samsung DSIM path:

```dts
samsung,esc-clock-frequency = <16000000>;
samsung,pll-clock-frequency = <26000000>;
```

This removed the r9 DSIM `-ENOENT` probe failure and allowed the panel/DRM chain to bind.

### Patch 18 - DECON enable lifecycle

`18-exynos7-decon-enable-lifecycle.patch.manual`

SHA-256:

```text
c54122ba2e701a1d7118c6f15588dfa3aa389ea4a405d5a61391cbc5e936621f
```

Linux 6.15 called `decon_commit()` while `ctx->suspended` was still true.
`decon_commit()` therefore returned before programming timings and scanout.
The patch moves `ctx->suspended = false` before the commit.

This is the minimal change that converted the r10 black-screen state into the
r11 hardware-proven display baseline.

## Integrity

See:
- [`SOURCE-SHA256SUMS`](SOURCE-SHA256SUMS) for original/materialized source bytes.
- [`STORED-SHA256SUMS`](STORED-SHA256SUMS) for the objects stored in this repository.
