#!/data/data/com.termux/files/usr/bin/bash
# install_picoclaw_termux.sh
# Version: 5
# Purpose: Set up Termux + PicoClaw on Android.
# Safe to re-run; it's idempotent where possible.

set -Eeuo pipefail

SCRIPT_VERSION="5"

# ---------- Helpers ----------
section() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
die() { echo -e "\n[ERROR] $*" >&2; exit 1; }
info() { echo -e "\033[1;32m[INFO]\033[0m $*"; }

# ---------- Remove PicoClaw ----------
remove_picoclaw() {
    section "Removing PicoClaw"
    local BIN_PATH="/data/data/com.termux/files/usr/bin/picoclaw"
    if [ -f "$BIN_PATH" ]; then
        rm -f "$BIN_PATH"
        info "Removed $BIN_PATH"
    else
        info "PicoClaw not found at $BIN_PATH"
    fi
    # Also check for config
    if [ -d "$HOME/.picoclaw" ]; then
        read -p "Remove PicoClaw config directory ($HOME/.picoclaw)? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.picoclaw"
            info "Removed config directory"
        fi
    fi
    info "PicoClaw removal complete"
    exit 0
}

# ---------- Show Version ----------
show_version() {
    echo "install_picoclaw_termux.sh version $SCRIPT_VERSION"
    exit 0
}

# ---------- Parse Args ----------
if [ $# -gt 0 ]; then
    case "$1" in
        --remove|-r)
            remove_picoclaw
            ;;
        --version|-v)
            show_version
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -r, --remove     Remove PicoClaw installation"
            echo "  -v, --version    Show script version"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
    esac
fi

info "install_picoclaw_termux.sh version $SCRIPT_VERSION"

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
