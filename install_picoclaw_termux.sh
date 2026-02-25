#!/data/data/com.termux/files/usr/bin/bash
# install_picoclaw_termux.sh
# Purpose: Set up Termux + PicoClaw on Android.
# Safe to re-run; it's idempotent where possible.

set -Eeuo pipefail

# ---------- Helpers ----------
section() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
die() { echo -e "\n[ERROR] $*" >&2; exit 1; }

# ---------- Config ----------
PICOCLAW_VERSION="v0.1.1"
PICOCLAW_BINARY="picoclaw-linux-arm64"
DOWNLOAD_URL="https://github.com/sipeed/picoclaw/releases/download/${PICOCLAW_VERSION}/${PICOCLAW_BINARY}"
TERMUX_BIN="/data/data/com.termux/files/usr/bin"

# ---------- Termux baseline ----------
section "Request storage access"
termux-setup-storage || true

section "Update Termux packages"
yes | pkg update || true
yes | pkg upgrade || true

section "Install wget"
pkg install -y wget || die "Failed to install wget"
pkg install -y termux-api || true

# ---------- PicoClaw ----------
section "Download PicoClaw ${PICOCLAW_VERSION}"
cd "$HOME"
wget -O picoclaw "${DOWNLOAD_URL}" || die "Failed to download PicoClaw"
chmod +x picoclaw

section "Install PicoClaw"
mv picoclaw "$TERMUX_BIN/picoclaw"
ls -la "$TERMUX_BIN/picoclaw" || die "Failed to install picoclaw"

section "Verify installation"
which picoclaw || die "picoclaw not in PATH"
picoclaw --version 2>/dev/null || true

# ---------- Final steps ----------
section "Run PicoClaw onboarding"
picoclaw onboard

section "Start PicoClaw gateway"
picoclaw run
