#!/bin/sh
set -eu

archive=""
for candidate in *.tar.gz *.tgz *.tar.xz; do
    if [ -f "$candidate" ]; then
        archive="$candidate"
        break
    fi
done

if [ -z "$archive" ]; then
    echo "No extra-data archive found in /app/extra" >&2
    exit 1
fi

bsdtar -xf "$archive"
rm -f "$archive"

# Set the asar's desktopName so the running app associates with our .desktop file.
# patch-desktop-filename (deprecated) and the new patch-electron-desktop-filename both
# read $FLATPAK_ID by default, which is NOT set during apply_extra (causes a crash).
# So we pass the id explicitly and don't rely on the environment.
if [ -f "resources/app.asar" ]; then
    if command -v patch-electron-desktop-filename >/dev/null 2>&1; then
        patch-electron-desktop-filename "resources/app.asar" --desktop-filename "de.billance.billance.desktop"
    else
        FLATPAK_ID="de.billance.billance" patch-desktop-filename "resources/app.asar"
    fi
fi

chmod 0755 billance
chmod 0755 chrome-sandbox
