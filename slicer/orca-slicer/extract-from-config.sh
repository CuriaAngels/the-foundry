#!/usr/bin/env bash
# Extract Orca Slicer user profiles from local config into this repo.
# Supports Flatpak (com.orcaslicer.OrcaSlicer) and legacy ~/.config installs.
# Run from repo root: ./slicer/orca-slicer/extract-from-config.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$SCRIPT_DIR"

FLATPAK_USER="$HOME/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer/user/default"
LEGACY_USER="${XDG_CONFIG_HOME:-$HOME/.config}/OrcaSlicer/user/default"

if [[ -d "$FLATPAK_USER" ]]; then
  ORCA_USER="$FLATPAK_USER"
elif [[ -d "$LEGACY_USER" ]]; then
  ORCA_USER="$LEGACY_USER"
else
  echo "Orca Slicer user config not found (checked Flatpak and ~/.config)"
  exit 1
fi

echo "Extracting from $ORCA_USER -> $DEST"

# Process presets
mkdir -p "$DEST/process"
cp -v "$ORCA_USER/process"/*.json "$ORCA_USER/process"/*.info "$DEST/process/" 2>/dev/null || true

# Filament presets
mkdir -p "$DEST/filament"
cp -v "$ORCA_USER/filament"/*.json "$ORCA_USER/filament"/*.info "$DEST/filament/" 2>/dev/null || true

# Machine/printer (if you add custom printer defs later)
mkdir -p "$DEST/printer"
cp -v "$ORCA_USER/machine"/*.json "$ORCA_USER/machine"/*.info "$DEST/printer/" 2>/dev/null || true

echo "Done. Commit and push to sync across machines."
