# Boot and Rollback Safety

## Scope

Applies to direct writes of boot-critical images or partitions during device development.

## Before flashing

The engineer SHOULD establish and retain:

- the exact target partition mapping;
- an original partition/image backup when feasible;
- a checksum of the rollback image;
- the candidate image checksum;
- candidate image size versus physical partition capacity;
- a tested or credible recovery path.

Do not infer a partition solely from a remembered number when a stable by-name mapping or recovery-environment mapping can be checked.

## After flashing

Where practical, read back the written byte range and compare its checksum to the source image.

Byte-exact readback proves the expected bytes were written. It does not prove the image boots or the hardware behaves correctly. Runtime boot and functional validation remain separate gates.

## Repository boundary

Large rollback images and raw partition dumps SHOULD remain outside this public knowledge repository. Publish hashes, sizes, partition identities, and reproducible procedures instead unless the binary artifact has a deliberate distribution purpose.
