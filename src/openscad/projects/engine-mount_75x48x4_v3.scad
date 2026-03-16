// Engine mount plate v3 — rounded body + all holes (no pockets, but keeps outer holes)
// Units: mm
// Reference: engine-mount_75x48x4.scad

$fn = 96;

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 4;           // thickness
R = 20;          // corner radius

// ---- Main hole parameters (MEASURE/CONFIRM) ----
holes = [
  // [x, y, diameter]
  [   0,  17,  7.7],   // top hole (placeholder)
  [   0,   0, 14],   // center big hole (placeholder)

  [ -14, -18, 7.7],   // bottom-left big hole (placeholder)
  [  14, -18, 7.7],   // bottom-right big hole (placeholder)

  [ -15,   0,  4],   // left small hole near center (placeholder)
  [  15,   0,  4],   // right small hole near center (placeholder)

  [   0, -15,  4]    // small bottom-center hole (placeholder)
];

// ---- Outer pocket holes (4 total: 2 left, 2 right) ----
pocket_hole_x = 27.5;        // distance from center to hole (X)
pocket_hole_y_top = 11.2;    // Y of top holes (2 & 3)
pocket_hole_y_bottom = 9.6;  // Y of bottom holes (1 & 4); placed at -y
pocket_hole_d = 3.2;         // diameter (M3 clearance)

module rounded_rect(w, h, r) {
  hull() {
    for (x = [-w/2 + r, w/2 - r])
      for (y = [-h/2 + r, h/2 - r])
        translate([x, y]) circle(r = r);
  }
}

difference() {
  // Solid plate
  linear_extrude(height = T)
    rounded_rect(W, H, R);

  // Through-holes (main pattern)
  for (h = holes)
    translate([h[0], h[1], -0.5])
      cylinder(h = T + 1, d = h[2]);

  // Outer holes: 2 on left, 2 on right
  for (sx = [-1, 1]) {
    for (sy = [-1, 1]) {
      translate([
        sx * pocket_hole_x,
        sy > 0 ? pocket_hole_y_top : -pocket_hole_y_bottom,
        -0.5
      ])
      cylinder(h = T + 1, d = pocket_hole_d);
    }
  }
}
