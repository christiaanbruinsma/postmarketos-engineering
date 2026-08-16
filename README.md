# PostMarketOS Engineering

**Current repository release: v0.2.0**

Practical, evidence-first engineering knowledge for postmarketOS device
development, kernel/package work, Device Tree debugging, recovery, rollback,
and hardware validation.

This repository records engineering decisions discovered during real hardware
work and keeps project-specific evidence separate from reusable guidance.

## Status

The retained Samsung Galaxy J5 (2017), `SM-J530F` / `j5y17lte`, baseline now
includes:

- a runtime- and reboot-proven touchscreen I2C controller fix;
- a hardware-proven native Exynos7870 display stack using DECON, Samsung DSIM,
  S6E8AA5X01 and the AMS520KT10 AMOLED panel;
- GNOME Mobile runtime evidence and renderer-isolation learnings.

The native display baseline is `linux-postmarketos-exynos7870` 6.15-r11,
runtime `#12-postmarketOS`, and has passed physical display, IRQ/MMIO,
DRM-timeout, systemd, and normal reboot gates.

No upstream postmarketOS submission is implied by material in this repository.
Device-specific patches may be retained here before, during, or independently
of an upstream contribution process.

## Start here

- [GOLDEN-STANDARD.md](GOLDEN-STANDARD.md) defines the evidence and promotion model.
- [PROJECT-CONFIGURATION.md](PROJECT-CONFIGURATION.md) defines the reproducible pmaports/device-development model.
- [DISCLAIMER.md](DISCLAIMER.md) explains the independent status and hardware-risk boundary.
- [devices/](devices/) contains device-specific engineering dossiers.
- [learnings/](learnings/) contains reusable lessons extracted from real work.
- [patterns/](patterns/) contains reusable engineering candidates.
- [standards/](standards/) contains the evidence-backed safety/documentation baseline.
- [templates/](templates/) contains repeatable documentation templates.

## Core principles

- Evidence before patches.
- Separate FACT, UNKNOWN, and HYPOTHESIS.
- Prefer the smallest change that matches the demonstrated root cause.
- Validate generated artifacts, not only source files.
- Runtime hardware proof is a distinct gate from build success.
- A reboot is a distinct gate from first-boot success when persistence matters.
- Preserve rollback material before destructive device writes.
- Never treat dynamic Linux bus numbering as proof of physical SoC controller identity.
- Keep device-specific fixes separate from reusable engineering rules.
- Public evidence must not expose unnecessary personal or machine-specific data.

## Knowledge promotion

```text
Observation
    |
Device/project-specific learning
    |
Reusable candidate
    |
Repeated or sufficiently strong evidence
    |
Engineering standard
```

Not every learning should become a pattern or standard.

## Public repository boundary

This is a public repository. Documentation should preserve technically useful
provenance while minimizing local identity and private data. Local usernames,
hostnames, serial numbers, IP addresses, credentials, tokens, and private
filesystem paths must not be published unless a specific technical requirement
justifies doing so.

See [standards/public-evidence-hygiene.md](standards/public-evidence-hygiene.md).
