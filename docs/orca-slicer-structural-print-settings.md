# Orca Slicer — Structural Parts (Engine Mount, CF)

Where to fill in what. No explanations—just paths and values.

---

## UI path format

**Process** → **Tab** → **Section** → **Field**: value

---

## Engine mount preset — fill in these

| Tab | Section | Field | Value |
|-----|---------|-------|-------|
| **Strength** | Infill | Sparse Infill Density | `100%` |
| **Strength** | Infill | Sparse Infill Pattern | `grid` or `triangles` |
| **Strength** | Walls | Wall Loops | `5` |
| **Strength** | Top and Bottom Shells | Top Shell Layers | `5` |
| **Strength** | Top and Bottom Shells | Bottom Shell Layers | `5` |

---

## UI structure

- **Process** (top) → **Global** → select preset (e.g. `0.20mm Standard @Creality K1C`)
- **Quality** tab sections: Precision, Ironing, Wall generator, Walls and surfaces
- **Strength** tab sections: Infill, Walls, Top and Bottom Shells
- Search box (magnifying glass): type field name to jump (e.g. `sparse`, `wall loops`)

---

## Alternative values

| Field | 100% strong | 80–90% lighter |
|-------|-------------|-----------------|
| Sparse Infill Density | `100%` | `80%` or `90%` |
| Wall Loops | `5` | `4` or `5` |
| Top/Bottom Shell Layers | `5` | `4` or `5` |

---

## Export preset

**File → Export → Export Configs** → Process → save to `slicer/orca-slicer/process/`
