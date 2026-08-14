# Public Evidence Hygiene

## Rule

Public engineering evidence MUST preserve technical reproducibility while minimizing unnecessary personal, machine-specific, or secret information.

## Publish when technically useful

Examples:

- device model and codename;
- package and kernel versions;
- source and commit SHAs;
- SoC/controller addresses;
- patch hashes;
- DTB/package/image hashes;
- relevant sanitized log lines;
- reproducible commands with generic paths.

## Sanitize or omit by default

- local usernames;
- hostnames;
- absolute private home-directory paths;
- device serial numbers and unique identifiers;
- IP addresses and local network details;
- credentials, API keys, tokens, cookies, and secrets;
- unrelated email addresses or author metadata copied from local tooling;
- raw recovery images or private backups.

Use `$HOME`, `<workspace>`, `<device>`, and similar placeholders where the exact local path is not technically relevant.

## Preserve originals privately

Do not rewrite or destroy original evidence merely to make it public-safe. Keep the original local artifact intact when it is needed for provenance, and publish a curated/sanitized representation separately.

## Review gate

Before a public commit containing logs, handovers, generated patches, screenshots, or diagnostic output:

1. search for local usernames and hostnames;
2. search for `/home/`, `/Users/`, IP addresses, serials, email addresses, tokens, and credentials;
3. inspect metadata-bearing formats such as `git format-patch` separately;
4. confirm that every retained identifier is technically useful or already part of the intended public upstream material.
