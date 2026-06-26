#!/bin/sh

export TMPDIR="$XDG_RUNTIME_DIR/app/$FLATPAK_ID"

if [ -n "$WAYLAND_DISPLAY" ]; then
    set -- --ozone-platform=wayland --enable-features=UseOzonePlatform "$@"
fi

exec zypak-wrapper /app/main/billance "$@"
