#!/data/data/com.termux/files/usr/bin/bash
# install_picoclaw_termux.sh
# Purpose: Set up Termux + PicoClaw on Android.
# PicoClaw is a single Go binary — no Ubuntu proot needed!
# Safe to re-run; it's idempotent where possible.

set -Eeuo pipefail

# ---------- Helpers ----------
section() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
die() { echo -e "\n[ERROR] $*" >&2; exit 1; }

# ---------- Config ----------
# Update this to the latest release version
PICOCLAW_VERSION="v0.1.1"
PICOCLAW_BINARY="picoclaw-linux-arm64"
DOWNLOAD_URL="https://github.com/sipeed/picoclaw/releases/download/${PICOCLAW_VERSION}/${PICOCLAW_BINARY}"

# ---------- Termux baseline ----------
section "Request storage access (you may see a prompt on device)"
termux-setup-storage || true

section "Update Termux packages"
yes | pkg update || true
yes | pkg upgrade || true

section "Install required packages: wget, termux-api"
pkg install -y wget || die "Failed to install wget"
pkg install -y termux-api || true

# ---------- PicoClaw ----------
section "Download PicoClaw ${PICOCLAW_VERSION}"
wget -O picoclaw "${DOWNLOAD_URL}" || die "Failed to download PicoClaw"
chmod +x picoclaw

section "Install PicoClaw to Termux bin directory"
# Install to $PREFIX/bin so it's in PATH immediately
mv picoclaw "$PREFIX/bin/picoclaw"

# ---------- Final steps ----------
section "Run PicoClaw onboarding"
picoclaw onboard || true

section "Start PicoClaw gateway — this will stay running"
picoclaw run
