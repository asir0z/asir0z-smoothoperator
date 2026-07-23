#!/usr/bin/env bash
# Install official Cursor AppImage — reproducible user install
# Target: ~/.local/opt/cursor/Cursor.AppImage + ~/.local/bin/cursor
set -euo pipefail

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) PLATFORM=linux-x64 ;;
  aarch64) PLATFORM=linux-arm64 ;;
  *) echo "unsupported arch: $ARCH" >&2; exit 1 ;;
esac

API="https://www.cursor.com/api/download?platform=${PLATFORM}&releaseTrack=stable"
INSTALL_DIR="${HOME}/.local/opt/cursor"
BIN_DIR="${HOME}/.local/bin"
DESKTOP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons/hicolor/256x256/apps"
APPIMAGE="${INSTALL_DIR}/Cursor.AppImage"
VERSION_FILE="${INSTALL_DIR}/VERSION"

command -v curl >/dev/null || { echo "curl required" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq required" >&2; exit 1; }

mkdir -p "$INSTALL_DIR" "$BIN_DIR" "$DESKTOP_DIR" "$ICON_DIR"

echo "--> Fetching Cursor metadata..."
RESPONSE="$(curl -fsSL "$API")"
URL="$(printf '%s' "$RESPONSE" | jq -r '.downloadUrl')"
VERSION="$(printf '%s' "$RESPONSE" | jq -r '.version // "unknown"')"

[[ -n "$URL" && "$URL" != "null" ]] || { echo "downloadUrl missing" >&2; exit 1; }

echo "--> Version: $VERSION"
echo "--> Downloading..."
curl -fL "$URL" -o "${APPIMAGE}.new"
chmod +x "${APPIMAGE}.new"
mv "${APPIMAGE}.new" "$APPIMAGE"
printf '%s\n' "$VERSION" >"$VERSION_FILE"

ln -sf "$APPIMAGE" "${BIN_DIR}/cursor"

cat >"${DESKTOP_DIR}/cursor.desktop" <<EOF
[Desktop Entry]
Name=Cursor
Comment=AI Code Editor
Exec=${APPIMAGE} --no-sandbox %F
Icon=cursor
Type=Application
Categories=Development;IDE;
Terminal=false
StartupWMClass=Cursor
EOF

# Extract icon if possible (best effort)
if command -v bsdtar >/dev/null 2>&1; then
  bsdtar -xf "$APPIMAGE" --strip-components=1 usr/share/icons/hicolor/256x256/apps/cursor.png -C "$ICON_DIR" 2>/dev/null || \
    cp /usr/share/pixmaps/co.anysphere.cursor.png "$ICON_DIR/cursor.png" 2>/dev/null || true
fi

echo "--> Installed: $APPIMAGE"
echo "--> Launcher: ${BIN_DIR}/cursor"
if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
  cursor --version 2>/dev/null || "$APPIMAGE" --version 2>/dev/null || true
else
  echo "(headless session — validate version via GUI: cursor or Win+E → Cursor)"
fi
