# Device Tree I2C Bus Mismatch Can Look Like a Driver Failure

## Context / problem

A touchscreen driver may probe and still fail to communicate with the hardware if the Device Tree attaches the device to the wrong physical I2C controller.

A typical symptom is an I2C transaction failure such as `-ENXIO` while the expected driver is otherwise present.

## Key distinction: adapter number versus controller identity

Linux runtime adapter numbers such as `i2c-2` are dynamically assigned and are not reliable names for the physical SoC controller.

When diagnosing bus placement, use the controller's hardware identity, for example its MMIO address or Device Tree node, rather than assuming `i2c-2` means hardware controller `i2c2`.

## Proven diagnostic path

1. Capture the driver's exact I2C failure.
2. Inspect the current Device Tree placement of the peripheral.
3. Compare against vendor or other authoritative hardware source evidence.
4. Map the vendor controller address to the mainline SoC controller label.
5. Change only the Device Tree bus if that is the demonstrated mismatch.
6. Build the real package/kernel.
7. Audit the generated DTB from the built artifact.
8. Confirm runtime enumeration under the expected physical controller.
9. Test the physical input device.
10. Reboot and repeat the functional test.

## Built-artifact audit

Do not stop at DTS inspection. If the package copies external devicetrees or applies patches during `prepare()`, the final DTB is the authoritative build artifact.

Decompiling the built DTB can prove that:

- the old controller no longer contains the peripheral;
- the intended controller is enabled;
- the peripheral node exists at the intended address.

## Change isolation

When a kernel package changes, comparing normalized module checksums between the control and test builds can help prove that unrelated kernel modules did not change.

In the originating case, all 292 kernel modules were byte-identical between the control and test packages, including the touchscreen module. The meaningful change was therefore isolated to the Device Tree/build artifact boundary.

## Warning discipline

A warning near the failing subsystem is not automatically causal. If the hardware works correctly after the demonstrated fix while a warning remains, do not expand scope without new evidence.

## Reusability

- **Device-specific:** exact controller labels, addresses, peripheral node, package flow, and patch.
- **Possibly reusable:** distinguish dynamic adapter numbering from physical controller identity; audit the generated DTB; use vendor DTS as evidence rather than as an unquestioned source of truth.
- **Strong general lesson:** build success alone is not hardware proof.

## Provenance

- Originating device: Samsung Galaxy J5 (2017), `SM-J530F` / `j5y17lte`
- Originating subsystem: Imagis IST3038H touchscreen
- Evidence types: source comparison, package build, generated DTB audit, module hash isolation, runtime enumeration, physical hardware test, reboot test
- Validation result: PASS within the documented device/software baseline
