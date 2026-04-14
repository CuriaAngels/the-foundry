// Engine mount plate v11 — same as v10; plate thickness T = 4 mm.
// Units: mm
// Reference: engine-mount_75x48x4_v10.scad

$fn = 96;

// Set true to show hole numbers on the plate (F5 preview); set false before F6 / STL export.
show_hole_labels = false;
hole_label_size = 3.5;   // mm, text height
hole_label_height = 0.35; // mm, extrusion from bottom face toward -Z

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 4;           // thickness
R = 20;          // corner radius

// Rectangular indent: 8 mm on X, 20 mm on Y, cuts from top (+Z) toward -Z
indent_depth = 1.5;
indent_wx = 8;
indent_wy = 20;

// ---- Main hole parameters (MEASURE/CONFIRM) ----
holes = [
  [   0,  14.5,  7.7],   // label 1 — top hole
  [   0,   0, 14],     // label 2 — center big hole
  [ -14, -15, 7.7],    // label 3 — bottom-left big hole
  [  14, -15, 7.7],    // label 4 — bottom-right big hole
  [ -12.5,   0,  4],     // label 5 — left small hole near center
  [  12.5,   0,  4],     // label 6 — right small hole near center
  [   0, -12,  4]      // label 7 — small bottom-center hole
];

pocket_holes = [
  [ -27.7,  3.5, 3.2],   // label 8
  [ -27.7, -7.2, 3.2],   // label 9
  [  27.7,  3.5, 3.2],   // label 10
  [  27.7, -7.2, 3.2],   // label 11
];

module rounded_rect(w, h, r) {
  hull() {
    for (x = [-w/2 + r, w/2 - r])
      for (y = [-h/2 + r, h/2 - r])
        translate([x, y]) circle(r = r);
  }
}

module top_indent(cx, cy) {
  translate([cx, cy, T - indent_depth / 2])
    cube([indent_wx, indent_wy, indent_depth + 0.02], center = true);
}

// Digit on bottom face: emboss below z=0, legible when camera looks from -Z (front; indents on +Z back)
module hole_label(n) {
  rotate([180, 0, 0])
    linear_extrude(height = hole_label_height)
      text(str(n), size = hole_label_size, halign = "center", valign = "center");
}

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
