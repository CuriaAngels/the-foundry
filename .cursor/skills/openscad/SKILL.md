---
name: openscad
description: >-
  Guides OpenSCAD modeling in the-foundry (paths, mm units, parametric style) and
  maps project needs to useful community libraries (BOSL2, MCAD, etc.) with vendoring
  under src/openscad/lib. Use when editing or creating .scad files, designing parts,
  or when the user asks which OpenSCAD library fits gears, threads, fillets, or imports.
---

# OpenSCAD (the-foundry)

## When to apply

- User works in `src/openscad/` or asks about OpenSCAD syntax, structure, or libraries.
- Prefer this skill together with the repo rule at `.cursor/rules/openscad.mdc` (syntax reference and layout).

## Project layout

| Path | Purpose |
|------|---------|
| `src/openscad/projects/<Project>/` | Per-project `.scad` files (subfolders by project name). |
| `src/openscad/lib/` | Vendored third-party libraries and shared local modules (`use` / `include` from projects via relative paths). |

Slicer UI paths and print settings live in `.cursor/rules/` (Orca, Prusa, etc.) — not in this skill.

## Conventions in this repo

- **Units**: millimeters unless the file states otherwise; say so in a top comment.
- **Resolution**: set `$fn` (or `$fa` / `$fs`) explicitly for reproducible meshes; raise `$fn` for final export if needed.
- **Structure**: top-level parameters, then helper modules/functions, then a single “root” boolean (often `difference()` / `union()`).
- **Iterating**: versioned filenames (e.g. `*_v2.scad`) are fine; keep one “current” variant clear in comments or name.

## Libraries — how the agent should help

**Goal:** Match **what the design needs** (operations and parts) to **libraries people actually use**, then give a **concrete install + `use` path** under `src/openscad/lib/`.

**Workflow:**

1. **Extract needs** from the project: e.g. involute gears, standard screw holes, threads, smooth fillets, complex 2D offset, SVG/DXF import helpers, organized attachments.
2. **Shortlist 1–3 candidates** (see table below). Prefer libraries that are actively maintained and documented. If unsure, say so and offer alternatives.
3. **Vendoring:** Clone or copy a **pinned release/tag** into `src/openscad/lib/<library-name>/`. Add a one-line comment in the project file: library name, version/commit, URL.
4. **Import:** Use `use` for libraries that only define modules/functions; `include` when the file must execute top-level code (rare; avoid if possible).
5. **Verify:** OpenSCAD version compatibility (some libs assume a minimum version). Check license if redistribution matters.

**Discovery beyond the table:** Use web search (for example `OpenSCAD involute gear library`) or GitHub search. The agent may suggest search terms; results change over time, so verify dates and last commits.

### Common mapping (starting points)

| Project need | Libraries often used | Notes |
|--------------|------------------------|--------|
| Rounded 3D edges, attachments, structured parts | [BOSL2](https://github.com/revarbat/BOSL2) | Large API; good for reusable mechanical patterns. |
| Nuts, bolts, washers, generic MCAD shapes | [MCAD](https://github.com/openscad/MCAD) | Classic utilities; check submodules/paths. |
| Involute gears | BOSL2 gears, or dedicated gear libs | Confirm module names in the vendored version. |
| Threads | MCAD threads / community thread libs | Match units and clearance to printing. |
| Knurled / textured cylinders | Small dedicated libs on GitHub | Search and pin a version. |
| Heavy 2D offset / hull patterns | Built-in `offset()`, BOSL2 2D helpers | Often no extra lib needed. |

If **no library** fits: prefer native OpenSCAD (smaller, fewer surprises) or a thin local module in `src/openscad/lib/local/`.

## References

- Official manual: [openscad.org/documentation.html](https://openscad.org/documentation.html)
- Repo layout rule: `.cursor/rules/openscad.mdc`
