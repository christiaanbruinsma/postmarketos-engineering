# Disclaimer

PostMarketOS Engineering is an independent, evidence-oriented engineering knowledge project.

It is provided for educational, reference, and engineering guidance purposes. It is **not official postmarketOS, Alpine Linux, Linux kernel, Samsung, or other upstream project documentation**, and no affiliation or endorsement is implied.

## Hardware and data risk

Mobile Linux development can involve bootloaders, partitions, kernels, Device Trees, recovery environments, and direct writes to storage. Incorrect commands, images, partition mappings, or assumptions can make a device unbootable or cause data loss.

Examples and retained evidence in this repository are not a substitute for identifying the exact device, partition layout, software version, and recovery path in front of you.

## Evidence has boundaries

A result described as **proven**, **verified**, **PASS**, or part of the **Golden Standard** is only proven within its documented evidence boundary: the device, versions, source baseline, implementation, test scope, validation gate, and other conditions actually examined.

A successful result on one hardware revision or software baseline does not guarantee the same result elsewhere.

## Always verify

Before relying on guidance from this repository:

- confirm the exact device and software baseline;
- consult current official upstream documentation where relevant;
- inspect current source rather than assuming historical paths or branches remain valid;
- preserve a tested recovery/rollback path before destructive writes;
- validate generated artifacts rather than assuming source or build success proves deployment correctness;
- perform your own runtime and post-reboot validation where applicable;
- treat anything not actually verified as UNKNOWN or NOT TESTED.

## No warranty

The documentation, patches, examples, patterns, configuration guidance, hashes, and other material are provided **as is** and **as available**, without warranties or guarantees of any kind, to the extent permitted by applicable law.

You remain responsible for evaluating, adapting, testing, flashing, validating, deploying, and maintaining anything you use from this repository.
