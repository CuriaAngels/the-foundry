// Engine mount plate v9 — from v8:
//   Step 1: holes 8 & 10 at Y = 3.9 (was 4.3 in v8)
//   Step 2–3: 1.5 mm deep top-face pocket (into -Z from top), 8 mm × 20 mm in XY,
//             centered on hole pairs 8–9 (left rail) and 10–11 (right rail)
// Units: mm
// Reference: engine-mount_75x48x4_v8.scad

$fn = 96;

// Set true to show hole numbers on the plate (F5 preview); set false before F6 / STL export.
show_hole_labels = true;
hole_label_size = 3.5;   // mm, text height
hole_label_height = 0.35; // mm, extrusion on +Z from top face

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 2;           // thickness
R = 20;          // corner radius

// Rectangular indent: 8 mm on X, 20 mm on Y, cuts 1.5 mm from top (+Z) toward bottom (-Z)
indent_depth = 1.5;
indent_wx = 8;
indent_wy = 20;

// ---- Main hole parameters (MEASURE/CONFIRM) ----
// Label # matches on-plate digits when show_hole_labels is true (order = 1 … len).
holes = [
  // [x, y, diameter]
  [   0,  14.5,  7.7],   // label 1 — top hole
  [   0,   0, 14],     // label 2 — center big hole
  [ -14, -15, 7.7],    // label 3 — bottom-left big hole
  [  14, -15, 7.7],    // label 4 — bottom-right big hole
  [ -12.5,   0,  4],     // label 5 — left small hole near center
  [  12.5,   0,  4],     // label 6 — right small hole near center
  [   0, -12,  4]      // label 7 — small bottom-center hole
];

// ---- Outer pocket holes (4 total: 2 left, 2 right) — same layout as v8 ----
// Labels continue after holes[] (here: 8 … 7+len(pocket_holes)).
pocket_holes = [
  // [x, y, diameter]
  [ -27.7,  3.9, 3.2],   // label 8 — left top (v8: 4.3)
  [ -27.7, -7.3, 3.2],   // label 9 — left bottom
  [  27.7,  3.9, 3.2],   // label 10 — right top (v8: 4.3)
  [  27.7, -7.3, 3.2],   // label 11 — right bottom
];

module rounded_rect(w, h, r) {
  hull() {
    for (x = [-w/2 + r, w/2 - r])
      for (y = [-h/2 + r, h/2 - r])
        translate([x, y]) circle(r = r);
  }
}

// Pocket from top: center (cx, cy), size indent_wx × indent_wy in XY
module top_indent(cx, cy) {
  translate([cx, cy, T - indent_depth / 2])
    cube([indent_wx, indent_wy, indent_depth + 0.02], center = true);
}

// Raised digit at hole center (XY), on top face (Z)
module hole_label(n) {
  translate([0, 0, T])
    linear_extrude(height = hole_label_height)
      text(str(n), size = hole_label_size, halign = "center", valign = "center");
}

// Midpoint between holes 8 & 9, and between 10 & 11 (same Y’s on both rails)
pair_y_center = (pocket_holes[0][1] + pocket_holes[1][1]) / 2;

union() {
  difference() {
    linear_extrude(height = T)
      rounded_rect(W, H, R);

    for (h = holes)
      translate([h[0], h[1], -0.5])
        cylinder(h = T + 1, d = h[2]);

    for (h = pocket_holes)
      translate([h[0], h[1], -0.5])
        cylinder(h = T + 1, d = h[2]);

    // Indents centered on pairs 8–9 (left) and 10–11 (right)
    top_indent(pocket_holes[0][0], pair_y_center);
    top_indent(pocket_holes[2][0], pair_y_center);
  }

  if (show_hole_labels) {
    color("crimson")
      for (i = [0 : len(holes) - 1])
        translate([holes[i][0], holes[i][1], 0])
          hole_label(i + 1);
    color("darkblue")
      for (i = [0 : len(pocket_holes) - 1])
        translate([pocket_holes[i][0], pocket_holes[i][1], 0])
          hole_label(len(holes) + i + 1);
  }
}
