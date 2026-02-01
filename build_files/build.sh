#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y --skip-unavailable emacs neovim coolercontrol liquidctl openrazer-daemon cmake libvterm libtool mupdf mupdf-devel mupdf-libs emacs-jinx
dnf5 --enablerepo=rpmfusion-nonfree -y install discord

dnf5 copr -y enable avengemedia/dms
dnf5 install -y --setopt=install_weak_deps=True niri dms
systemctl --global add-wants niri.service dms
dnf5 copr -y enable scottames/ghostty
dnf5 install -y ghostty
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable scottames/ghostty

dnf5 install -y kernel-devel
dnf5 config-manager -y addrepo --from-repofile=https://openrazer.github.io/hardware:razer.repo
dnf5 install -y openrazer-meta

dnf5 -y copr enable jfaracco/amdgpu_top
dnf5 -y install amdgpu_top
dnf5 -y copr disable jfaracco/amdgpu_top
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
