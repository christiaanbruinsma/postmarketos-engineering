# postmarketOS Engineering Project Configuration

This document defines a reproducible working model for device development and debugging without assuming prior session context.

It intentionally avoids hard-coding installation instructions that may change upstream. Use current official postmarketOS documentation to install or update `pmbootstrap` and its dependencies.

## 1. Workspace model

Keep the knowledge repository separate from pmaports and from large local evidence:

```text
$HOME/Mobile-Linux-Lab/
├── postmarketos-engineering/      # public engineering knowledge repository
└── <device-workspace>/            # local pmaports worktrees, builds, audits, backups
```

Do not place raw boot images, large package artifacts, private logs, or recovery dumps in the public knowledge repository.

## 2. pmaports as source of truth

Before modifying a package:

1. inspect the active pmaports remote and development branch;
2. record the exact baseline commit;
3. inspect the current package version, release, source commit, and prepare flow;
4. create an isolated branch or worktree for the fix;
5. keep the baseline recoverable until publication or cleanup is explicitly approved.

Do not assume a historical branch name, package release, or source commit remains current.

## 3. Worktree discipline

Prefer an isolated Git worktree or dedicated checkout for hardware-facing patches. Record:

- worktree purpose;
- branch name;
- baseline commit;
- local fix commit;
- whether anything has been pushed upstream.

Never delete a retained worktree merely because the fix has been copied into this repository. First verify that all required patch material, provenance, and evidence have been preserved elsewhere.

## 4. Evidence-first debugging

Classify findings explicitly:

- **FACT**: directly supported by logs, source, tests, hashes, or hardware behavior.
- **UNKNOWN**: not yet established.
- **HYPOTHESIS**: a falsifiable explanation with a concrete test.

Do not patch around a warning just because it appears near the failing subsystem. Establish whether it is causally relevant.

## 5. Device Tree workflow

When debugging a Device Tree issue:

1. inspect the source DTS/DTSI actually used by the package;
2. identify the physical SoC controller/resource from hardware or vendor evidence;
3. distinguish hardware controller identity from Linux runtime numbering;
4. patch the correct source stage;
5. build the package/kernel;
6. extract or inspect the DTB from the built artifact;
7. decompile or otherwise verify the generated DTB when useful;
8. test on physical hardware;
9. repeat after reboot when persistence matters.

Source inspection alone does not prove the built DTB contains the intended change.

## 6. Patch timing

Alpine `default_prepare()` applies normal package patches early. When a package copies external Device Tree sources into the kernel tree later in `prepare()`, a normal `.patch` may target a file that does not yet exist.

In that case, an explicitly named manual patch and a deliberate later `patch -p1` invocation can be appropriate. The package flow itself must be inspected before choosing this pattern.

## 7. Build targeting

When multiple pmaports trees/worktrees exist, pass the intended tree explicitly to tooling rather than relying on an implicit cache checkout.

Example form:

```bash
pmbootstrap -p /path/to/intended/pmaports build --arch aarch64 --force <kernel-package>
```

The exact architecture and package are device-specific.

## 8. Artifact validation

Retain checksums for evidence-bearing outputs when practical:

- patch files;
- changed package metadata;
- built packages;
- generated DTBs;
- boot images;
- flash readbacks;
- normalized module manifests when change isolation matters.

A checksum proves byte identity, not semantic correctness. Pair hashes with the appropriate semantic/runtime gate.

## 9. Boot and recovery safety

Before writing a boot-critical partition, determine and record:

- the correct partition/by-name mapping;
- the original image size and checksum;
- the rollback image location outside the public repository;
- the candidate image size and checksum;
- whether it fits the physical partition;
- the recovery path if boot fails.

After flashing, readback and hash the written byte range when practical and meaningful.

See [standards/boot-and-rollback-safety.md](standards/boot-and-rollback-safety.md).

## 10. Public documentation

Use stable technical identifiers such as device codename, package name, kernel version, commit SHA, register/controller address, and artifact hash.

Do not publish unnecessary:

- local usernames;
- hostnames;
- absolute private home paths;
- device serial numbers;
- IP addresses;
- credentials or tokens;
- private recovery material.

Use `$HOME`, `/path/to/...`, or descriptive placeholders where local paths are not technically material.
