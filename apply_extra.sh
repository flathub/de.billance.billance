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

if [ -f "resources/app.asar" ]; then
    patch-desktop-filename "resources/app.asar"
fi

chmod 0755 billance || true
chmod 0755 chrome-sandbox || true
