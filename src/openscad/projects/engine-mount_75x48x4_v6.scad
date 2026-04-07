// Engine mount plate v3 — rounded body + all holes (no pockets, but keeps outer holes)
// Units: mm
// Reference: engine-mount_75x48x4.scad

$fn = 96;

// Set true to show hole numbers on the plate (F5 preview); set false before F6 / STL export.
show_hole_labels = true;
hole_label_size = 3.5;   // mm, text height
hole_label_height = 0.35; // mm, extrusion on +Z from top face

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 4;           // thickness
R = 20;          // corner radius

// ---- Main hole parameters (MEASURE/CONFIRM) ----
// Label # matches on-plate digits when show_hole_labels is true (order = 1 … len).
holes = [
  // [x, y, diameter]
  [   0,  14,  7.7],   // label 1 — top hole
  [   0,   0, 14],     // label 2 — center big hole
  [ -14, -15, 7.7],    // label 3 — bottom-left big hole
  [  14, -15, 7.7],    // label 4 — bottom-right big hole
  [ -12.5,   0,  4],     // label 5 — left small hole near center
  [  12.5,   0,  4],     // label 6 — right small hole near center
  [   0, -12,  4]      // label 7 — small bottom-center hole
];

// ---- Outer pocket holes (4 total: 2 left, 2 right) ----
// Labels continue after holes[] (here: 8 … 7+len(pocket_holes)).
pocket_holes = [
  // [x, y, diameter] — same convention as holes[]
  [ -27.5,  4.3, 3.2],   // label 8 — left top
  [ -27.5,  -7.6, 3.2],  // label 9 — left bottom
  [  27.5,  4.3, 3.2],   // label 10 — right top
  [  27.5,  -7.6, 3.2],  // label 11 — right bottom
];

module rounded_rect(w, h, r) {
  hull() {
    for (x = [-w/2 + r, w/2 - r])
      for (y = [-h/2 + r, h/2 - r])
        translate([x, y]) circle(r = r);
  }
}

// Raised digit at hole center (XY), on top face (Z)
module hole_label(n) {
  translate([0, 0, T])
    linear_extrude(height = hole_label_height)
      text(str(n), size = hole_label_size, halign = "center", valign = "center");
}

union() {
  difference() {
    // Solid plate
    linear_extrude(height = T)
      rounded_rect(W, H, R);

    // Through-holes (main pattern)
    for (h = holes)
      translate([h[0], h[1], -0.5])
        cylinder(h = T + 1, d = h[2]);

    // Outer pocket holes
    for (h = pocket_holes)
      translate([h[0], h[1], -0.5])
        cylinder(h = T + 1, d = h[2]);
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
