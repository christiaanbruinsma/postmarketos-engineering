# Runtime evidence - native Exynos7870 display

## Result

**Panel 19.24 / r11 is the first stable hardware-proven native display baseline.**

Tested device:

- Samsung Galaxy J5 (2017), SM-J530F, `j5y17lte`
- Exynos 7870, aarch64
- postmarketOS v26.06
- kernel package `linux-postmarketos-exynos7870-6.15-r11`
- runtime `6.15.0-exynos7870 #12-postmarketOS`
- GNOME Mobile

Validated chain:

```text
Exynos DRM
-> DECON
-> Samsung DSIM / MIPI DSI
-> Samsung S6E8AA5X01 / AMS520KT10
-> physical AMOLED
```

## r9 - DSIM probe blocker

The r9 runtime failed with:

```text
exynos-dsi 14800000.dsi: probe with driver exynos-dsi failed with error -2
```

The live DSI node exposed clocks named `bus`, `pll`, `byte`, and `esc`, but did not
provide `samsung,pll-clock-frequency` or `samsung,esc-clock-frequency`.
Patch 17 added the proven 26 MHz PLL input and 16 MHz escape clock values.

## r10 - DRM active, scanout absent

After patch 17:

- DSIM no longer failed with `-2`;
- the panel attached;
- DECON and DSIM bound;
- Exynos DRM initialized;
- `fb1: exynosdrmfb` existed;
- DRM reported a connected 720x1280 DSI output.

The display nevertheless stayed black and DRM logged vblank, flip-done, and commit
timeouts.

Read-only DECON MMIO showed initialization state but no programmed timing/scanout:
`VIDCON0 = 0`, timing registers were zero, and the line counter did not advance.
The DECON IRQ count remained stuck at `1 -> 1`.

## Root cause

In Linux 6.15, `decon_atomic_enable()` called:

```c
decon_init(ctx);
decon_commit(ctx->crtc);
ctx->suspended = false;
```

while `decon_commit()` begins by returning when `ctx->suspended` is true.

The enable path therefore never committed timing/scanout state.

Patch 18 changes only the lifecycle ordering:

```c
decon_init(ctx);
ctx->suspended = false;
decon_commit(ctx->crtc);
```

## r11 - hardware proof

With patch 18:

- the physical AMOLED produced a visible image immediately;
- GNOME Mobile reached login and desktop;
- touch remained operational;
- DECON IRQ advanced from `1918` to `1979` over two seconds;
- no DRM vblank/flip/commit timeout was observed;
- `systemctl --failed` reported zero failed units.

Read-only DECON MMIO showed active scanout:

```text
VIDCON0        = 0x00000007
VCLKCON1       = 0x00000001
VCLKCON2       = 0x00000001
VIDCON1        = 0x030a6000
VIDTCON0       = 0x0007000d
VIDTCON1       = 0x00010000
VIDTCON2       = 0x003b0081
VIDTCON3       = 0x00130000
VIDTCON4       = 0x04ff02cf
```

The line counter changed continuously, including values `406`, `1199`, `686`,
`173`, `965`, `452`, `1243`, `730`, `217`, and `1008`. This directly proves
active 720x1280 scanout rather than a userspace-only DRM state.

## Reboot gate

A normal `systemctl reboot` passed:

- no Download Mode recovery path was entered;
- display output returned;
- boot text appeared;
- GNOME login returned;
- touch worked;
- runtime remained kernel `#12-postmarketOS`;
- display timeout signature remained absent.

## Frozen evidence

The original runtime files are stored as deterministic XZ archives under
`evidence/r10/` and `evidence/r11/`. Run `./materialize.sh` to restore them.

Original SHA-256:

```text
f99e4de0b73d742924999f6fe2f0f6ac71359ee53fb164bf2a0a8661b29a40f7  evidence/r10/r10-display-runtime.txt
fc8856e7b14f0f0005bb91a16e88a4502b18046eb1fd8cbe9d4eb91ad62b28a0  evidence/r10/r10-decon-mmio.txt
862d23854fb0ca6eb24a4b788886a1744e14cd2dc76b1cc49b5af196fbf30ef6  evidence/r11/r11-display-runtime.txt
6cdc41bcea2d4f2a51e36e05874a226ed4b5f04cf740240a25fef5f9f22ba424  evidence/r11/r11-decon-mmio.txt
```

## Safety and remaining work

The working display baseline must not be disturbed merely to silence unrelated
warnings. Remaining warnings include dummy regulator/device-link messages,
boot protocol/alignment warnings, alternate GPT fallback, generic brcmfmac
firmware fallback, and the DECON deferred-probe message seen during boot.

A separate CMA allocation-pressure observation remains under investigation.
No CMA size change is justified by the evidence retained here.
