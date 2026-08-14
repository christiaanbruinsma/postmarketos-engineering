# Golden Standard

## Definition

The **PostMarketOS Engineering Golden Standard** is this project's current evidence-backed baseline for device-development work, debugging, package/kernel changes, hardware validation, recovery, and retained engineering evidence.

It is independent engineering reference material. It is not official postmarketOS, Alpine Linux, Linux kernel, Samsung, or other upstream project documentation.

"Golden Standard" does not mean universal, permanent, infallible, or officially endorsed. A rule is only as strong as its documented evidence boundary.

## What proven means

A claim is **proven** only within the conditions actually tested.

Evidence may include:

- source inspection;
- vendor or upstream source comparison;
- static validation;
- package or kernel build output;
- generated DTB or artifact inspection;
- module or file checksum comparison;
- boot-image readback verification;
- runtime kernel output;
- physical hardware behavior;
- post-reboot behavior;
- a working patch followed by retesting.

These gates are not interchangeable:

```text
source looks correct ≠ built artifact is correct
build PASS ≠ runtime PASS
runtime PASS once ≠ post-reboot PASS
patch applies ≠ hardware root cause is proven
dynamic Linux adapter number ≠ physical SoC controller identity
```

## Evidence model

Knowledge moves upward only when the evidence supports it:

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

### Observation

Something has been seen in source, logs, hardware behavior, tooling, or documentation, but its cause or reusability may still be unknown.

### Device/project-specific learning

The root cause and solution are sufficiently demonstrated for a specific device or project.

### Reusable candidate

The technical reasoning is expected to transfer to other device-porting work, but the repository does not yet claim universal applicability.

### Engineering standard

The evidence and risk model are strong enough for this repository to adopt the rule as a default engineering baseline when applicable.

## Normative language

- **MUST**: required for conformance when applicable.
- **SHOULD**: evidence-backed default; deviation should have a technical reason.
- **MAY**: optional and context-dependent.
- **UNKNOWN**: evidence is insufficient.
- **NOT TESTED**: applicable but not verified.
- **N/A**: genuinely not applicable.

UNKNOWN and NOT TESTED must never be silently converted to PASS.

## Patch gate

A hardware-facing patch should not be called stable merely because it compiles. The applicable gate should distinguish:

1. source/root-cause evidence;
2. patch scope review;
3. static validation;
4. package/kernel build;
5. generated-artifact validation;
6. runtime hardware validation;
7. reboot validation when persistence matters;
8. rollback readiness for destructive writes.

The exact gate can differ per change. Non-applicable items must be documented as N/A rather than omitted.

## Device-specific evidence boundary

A device fix belongs under `devices/` first. Only the reusable lesson should be promoted to `learnings/`, `patterns/`, or `standards/`.

A working patch for one phone does not prove that the same patch belongs on another phone, board revision, kernel branch, or package version.

## Public evidence boundary

Public reproducibility does not require publishing private local identity. Evidence should use stable technical identifiers and hashes while sanitizing unnecessary local usernames, hostnames, private paths, serial numbers, network addresses, credentials, tokens, and similar data.

The original private/local evidence may remain unchanged outside the repository. Sanitization applies to what is published.
