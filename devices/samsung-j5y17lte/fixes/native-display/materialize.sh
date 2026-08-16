#!/bin/sh
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

need() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "Missing required tool: $1" >&2
		exit 1
	}
}

need xz
need sha256sum

# Restore the large upstream panel-base patch.
xz -dc patches/14-s6e8aa5x01-panel-base-v6.15.patch.manual.xz \
	> patches/14-s6e8aa5x01-panel-base-v6.15.patch.manual

# Restore the exact r11 kernel config.
cat pmaports/config-postmarketos-exynos7870.aarch64.xz.part-* \
	> pmaports/config-postmarketos-exynos7870.aarch64.xz
xz -dc pmaports/config-postmarketos-exynos7870.aarch64.xz \
	> pmaports/config-postmarketos-exynos7870.aarch64
rm -f pmaports/config-postmarketos-exynos7870.aarch64.xz

# Restore frozen runtime evidence.
for f in \
	evidence/r10/r10-display-runtime.txt \
	evidence/r10/r10-decon-mmio.txt \
	evidence/r11/r11-display-runtime.txt \
	evidence/r11/r11-decon-mmio.txt
do
	xz -dc "$f.xz" > "$f"
done

sha256sum -c SOURCE-SHA256SUMS
echo "PASS: native-display source and evidence materialized byte-exact."
