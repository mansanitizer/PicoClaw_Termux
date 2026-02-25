# PicoClaw_Termux

Install [PicoClaw](https://github.com/sipeed/picoclaw) on Android via Termux — single-command installer.

PicoClaw is an ultra-lightweight AI assistant written in Go. It runs as a single binary with <10MB RAM, making it perfect for Android phones.

## Prerequisites

- Android phone
- [Termux](https://f-droid.org/en/packages/com.termux/) from F-Droid (not Google Play)
- [Termux:API](https://f-droid.org/en/packages/com.termux.api/) from F-Droid (optional, for device access)

## Installation

```bash
pkg install -y wget openssl
wget https://raw.githubusercontent.com/mansanitizer/PicoClaw_Termux/main/install_picoclaw_termux.sh
chmod +x install_picoclaw_termux.sh
./install_picoclaw_termux.sh
```

## What it does

1. Updates Termux packages
2. Installs `wget`, `proot`, and `termux-api`
3. Downloads the PicoClaw ARM64 binary from GitHub releases
4. Runs `picoclaw onboard` for initial setup
5. Starts the PicoClaw gateway

## Why PicoClaw on Termux?

- **No root required**
- **No Ubuntu proot needed** — single Go binary
- **<10MB RAM** — runs on any Android phone
- **1s boot time** — instant startup
- Connect via WhatsApp, Telegram, or Discord

## Credits

- [PicoClaw](https://github.com/sipeed/picoclaw) by Sipeed
- Inspired by [androidmalware/OpenClaw_Termux](https://github.com/androidmalware/OpenClaw_Termux)
