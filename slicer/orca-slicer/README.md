# Orca Slicer

Orca Slicer profiles (printer, process, filament). Same format as PrusaSlicer/Bambu Studio.

## Recover on a new machine

1. Clone this repo (or pull latest).
2. In Orca Slicer: **File → Import → Import Configs**
3. Select this folder: `slicer/orca-slicer/`
4. Your process presets and filament profiles will be imported.

## Export / update profiles

**Option A – from Orca Slicer (recommended):**  
**File → Export → Export Configs** → choose Process/Filament/Printer → save into this folder.

**Option B – copy from config directory (Linux):**
```bash
# From repo root
./slicer/orca-slicer/extract-from-config.sh
```
This copies from `~/.config/OrcaSlicer/user/default/` into this folder.
