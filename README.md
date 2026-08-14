# PostMarketOS Engineering

**Current repository release: v0.1.0**

Practical, evidence-first engineering knowledge for postmarketOS device development, kernel/package work, Device Tree debugging, recovery, rollback, and hardware validation.

This repository is not a generic collection of mobile Linux tips. It records engineering decisions discovered during real hardware work and keeps project-specific evidence separate from reusable guidance.

## Status

The first retained case is a Samsung Galaxy J5 (2017), `SM-J530F` / `j5y17lte`, touchscreen Device Tree fix. The fix was validated through package build, built-DTB inspection, physical touchscreen operation, and a full reboot.

No upstream postmarketOS submission is implied by material in this repository. Device-specific patches may be retained here before, during, or independently of any upstream contribution process.

## Start here

- [GOLDEN-STANDARD.md](GOLDEN-STANDARD.md) defines the evidence and promotion model.
- [PROJECT-CONFIGURATION.md](PROJECT-CONFIGURATION.md) defines the reproducible working model for pmaports, pmbootstrap, worktrees, builds, and evidence.
- [DISCLAIMER.md](DISCLAIMER.md) explains the independent status and hardware-risk boundary of this repository.
- [devices/](devices/) contains device-specific engineering dossiers.
- [learnings/](learnings/) contains reusable lessons extracted from real work.
- [patterns/](patterns/) contains reusable candidates that have stronger general engineering value but are not automatically universal rules.
- [standards/](standards/) contains the repository's current evidence-backed safety and documentation baseline.
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
    ↓
Device/project-specific learning
    ↓
Reusable candidate
    ↓
Repeated or sufficiently strong evidence
    ↓
Engineering standard
```

Not every learning should become a pattern or standard.

## Public repository boundary

This is a public repository. Documentation should preserve technically useful provenance while minimizing local identity and private data. Local usernames, hostnames, serial numbers, IP addresses, credentials, tokens, and private filesystem paths must not be published unless a specific technical requirement justifies doing so.

See [standards/public-evidence-hygiene.md](standards/public-evidence-hygiene.md).
