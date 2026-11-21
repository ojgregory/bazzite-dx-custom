#!/usr/bin/env bash
set -euo pipefail

KVER="$(ls -1 /usr/lib/modules | head -n1)"
BUILD_PACKAGES=(gcc make git "kernel-devel-${KVER}")

dnf5 install -y "${BUILD_PACKAGES[@]}"

SRC_DIR="/tmp/Hermes-KMS"
rm -rf "${SRC_DIR}"
git clone --depth 1 https://github.com/MrOz59/Hermes-KMS.git "${SRC_DIR}"

# Run from the repository root (/tmp/Hermes-KMS), NOT kernel/hermes-kms
make -C "${SRC_DIR}" modules \
  KERNELRELEASE="${KVER}" \
  KDIR="/usr/lib/modules/${KVER}/build"

make -C "${SRC_DIR}" modules-install install-configs \
  KERNELRELEASE="${KVER}" \
  DESTDIR=/

depmod -a "${KVER}"

dnf5 remove -y "${BUILD_PACKAGES[@]}"
dnf5 clean all
rm -rf "${SRC_DIR}"
