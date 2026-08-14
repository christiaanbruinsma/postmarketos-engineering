# GTK4 renderer isolation on Mali-T830 / Panfrost

## Scope

This learning records a renderer fault isolated on a Samsung Galaxy J5 (2017), `j5y17lte`, running postmarketOS v26.06 with kernel `6.15.0-exynos7870`, Mesa `26.1.6-r0`, GNOME Mobile, and a Mali-T830 GPU through Panfrost.

The result is a device-specific workaround and a reusable diagnostic method. It does not prove the root cause inside Mesa, Panfrost, GTK, or Mutter.

## Symptom

GTK4 interfaces could visibly flicker while scrolling. The displayed frame could also appear out of sync with the UI state, making touch input look offset from the element shown on screen.

Before changing touchscreen calibration, the input and display coordinate spaces were verified.

- DRM display mode: `720x1280`
- Touch `ABS_X`: `0..719`
- Touch `ABS_Y`: `0..1279`
- Touch `ABS_MT_POSITION_X`: `0..719`
- Touch `ABS_MT_POSITION_Y`: `0..1279`

This is an exact coordinate-space match. No raw touchscreen scaling mismatch was found.

## GPU evidence

The kernel repeatedly reported Panfrost job-slot faults with:

```text
status=INSTR_INVALID_ENC
```

A controlled scroll test in GNOME Settings produced the following result:

| Test | Panfrost fault count | Visual result |
| --- | ---: | --- |
| Idle control | no increase during prior idle sample | stable |
| Normal GTK renderer, ~10 s scroll | `448 -> 669` (`+221`) | flickering / stale-looking frames |
| Cairo renderer, ~10 s scroll | `700 -> 700` (`+0`) | smooth and visually correct |
| Forced `gl` renderer | not accepted as stable | severe visual corruption |

A sampled burst of the failing normal-renderer test contained only `INSTR_INVALID_ENC` faults. The faults arrived at roughly frame cadence during the burst.

The A/B result strongly isolates the visible corruption to the accelerated GTK/GSK graphics path on this software and hardware baseline. It does not establish which lower-level component emits the invalid instruction stream.

## Workaround

For GTK4 applications on this device, forcing the Cairo renderer removed the reproduced fault storm and restored smooth Settings scrolling:

```sh
GSK_RENDERER=cairo
```

For the current user session, the variable can be exported into the D-Bus/systemd activation environment before launching a fresh GTK application:

```sh
export GSK_RENDERER=cairo
dbus-update-activation-environment --systemd GSK_RENDERER
```

For a persistent per-user configuration:

```sh
mkdir -p ~/.config/environment.d
printf '%s\n' 'GSK_RENDERER=cairo' > ~/.config/environment.d/90-gsk-renderer.conf
```

The persistent file has been installed on the tested device. Cold-boot persistence remains a separate validation gate and should be recorded only after a later reboot test.

## Why this is a workaround, not a fix

Cairo avoids the failing accelerated GTK renderer path. It may use more CPU and power than a working GPU-accelerated path.

Do not interpret this result as proof that:

- the touchscreen needs calibration;
- Panfrost is universally broken on Mali-T830;
- GNOME Settings itself is the root cause;
- Cairo should be forced on every postmarketOS device.

The evidence only supports the tested device/software combination.

## Diagnostic lesson

When a graphical fault makes touch appear offset, separate input coordinates from displayed-frame correctness before calibrating input.

A useful sequence is:

1. verify the DRM mode;
2. verify the raw absolute touchscreen ranges;
3. establish an idle GPU-fault baseline;
4. reproduce one visual action such as scrolling;
5. measure the fault delta;
6. change exactly one renderer variable;
7. repeat the same action and compare both logs and visible behavior.

This prevented a correct touchscreen configuration from being modified in response to a rendering fault.
