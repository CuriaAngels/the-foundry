# the-foundry

3D printing project repository: OpenSCAD designs, CAD models, and slicer configs for multiple printers.

## Structure

```
├── src/
│   ├── openscad/          # OpenSCAD source files
│   │   ├── lib/           # Shared modules (BOSL2, etc.)
│   │   └── projects/     # Per-project .scad files
│   └── models/            # STEP, OBJ, other CAD sources
├── slicer/                # Slicer profiles (one folder per slicer)
│   ├── orca-slicer/       # Orca Slicer
│   ├── prusa-slicer/      # PrusaSlicer
│   ├── bambu-studio/      # Bambu Studio
│   └── cura/              # Cura
├── build/                 # Generated STL, G-code (gitignored)
└── docs/                  # Print notes, calibration, BOMs
```

## Slicer Configs

Each slicer has its own folder with `printer/`, `process/`, and `filament/` (or equivalent). Add your printer profiles and export your configs into the appropriate slicer folder.

| Printer       | Slicer       | Notes                    |
|---------------|--------------|--------------------------|
| Creality K1C  | Orca Slicer  | Primary                  |
| Bambu Lab P2S | Orca/Bambu   | AMS 2 Pro, multi-material |
| Bambu Lab A1  | Orca/Bambu   | Single material          |

See each slicer's `README.md` for import/export instructions.

## K1C Profiles (Orca Slicer)

Orca Slicer does not ship K1C profiles by default. Community profiles (compatible with K1 Max) are available from [Printables](https://www.printables.com/model/536422-creality-k1k1-max-orcaslicer-profile/files) or [open-rdc/Creality-K1-Slicer-Profiles](https://github.com/open-rdc/creality-k1-slicer-profiles). Import them, then export to `slicer/orca-slicer/` to version your tweaks.

## References

- [OpenSCAD Documentation](https://openscad.org/documentation.html)
- [Orca Slicer Wiki](https://orca-slicer.com/wiki/)
