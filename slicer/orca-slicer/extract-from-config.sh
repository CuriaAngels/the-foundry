#!/usr/bin/env bash
# Extract Orca Slicer user profiles from ~/.config/OrcaSlicer into this repo.
# Run from repo root: ./slicer/orca-slicer/extract-from-config.sh

set -e
ORCA_USER="${XDG_CONFIG_HOME:-$HOME/.config}/OrcaSlicer/user/default"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$SCRIPT_DIR"

if [[ ! -d "$ORCA_USER" ]]; then
  echo "Orca Slicer user config not found: $ORCA_USER"
  exit 1
fi

echo "Extracting from $ORCA_USER -> $DEST"

# Process presets
mkdir -p "$DEST/process"
cp -v "$ORCA_USER/process"/*.json "$ORCA_USER/process"/*.info "$DEST/process/" 2>/dev/null || true

# Filament presets (preserve base/ subdir)
mkdir -p "$DEST/filament/base"
cp -v "$ORCA_USER/filament/base"/*.json "$ORCA_USER/filament/base"/*.info "$DEST/filament/base/" 2>/dev/null || true

# Machine/printer (if you add custom printer defs later)
mkdir -p "$DEST/printer"
cp -v "$ORCA_USER/machine"/*.json "$ORCA_USER/machine"/*.info "$DEST/printer/" 2>/dev/null || true

echo "Done. Commit and push to sync across machines."
