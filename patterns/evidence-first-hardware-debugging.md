# Evidence-First Hardware Debugging

**Status:** reusable candidate

## Principle

Treat hardware debugging as a sequence of falsifiable boundaries rather than a search for nearby warnings to patch.

## Working model

1. Capture the exact failure and error code.
2. Identify what the error proves and what it does not prove.
3. Map runtime resources back to physical hardware identities.
4. Compare current source with authoritative hardware/vendor evidence where available.
5. Form the smallest falsifiable hypothesis.
6. Patch only the demonstrated boundary.
7. Build and inspect the generated artifact.
8. Validate on physical hardware.
9. Reboot and retest when persistence matters.
10. Isolate unrelated changes with checksums or targeted comparisons when needed.

## Why this matters

Hardware stacks contain many warnings and fallback paths. A visible warning can coexist with a fully working subsystem. Conversely, a source file can look correct while the packaged DTB or flashed image is wrong.

The method therefore separates source evidence, build evidence, artifact evidence, runtime evidence, and reboot evidence.

## Originating evidence

The first retained case is the `j5y17lte` touchscreen failure where the driver was present but the Device Tree placed the device on the wrong physical I2C controller. The final fix changed only the bus node and passed build, DTB, runtime, and reboot gates.
