// Engine mount plate (rough) — now includes the 4 pocket holes.
// Units: mm

$fn = 96;

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 4;           // thickness
R = 12;          // corner radius (try 12–24; 24 makes it more capsule-like)

// ---- Main hole parameters (MEASURE/CONFIRM) ----
holes = [
  // [x, y, diameter]
  [   0,  16,  10],   // top hole (placeholder)
  [   0,   0, 18],   // center big hole (placeholder)

  [ -18, -16, 10],   // bottom-left big hole (placeholder)
  [  18, -16, 10],   // bottom-right big hole (placeholder)

  [ -16,   0,  4],   // left small hole near center (placeholder)
  [  16,   0,  4],   // right small hole near center (placeholder)

  [   0, -14,  4]    // small bottom-center hole (placeholder)
];

ENABLE_SIDE_POCKETS = true;
pocket_depth = 1.5;     // recess depth (set 0 to disable recess effect)
pocket_w = 14;          // pocket width (X direction)
pocket_h = 34;          // pocket height (Y direction)
pocket_x_offset =  (W/2) - (pocket_w/2) - 3;  // adjust the "3" to slide pocket in/out

ENABLE_POCKET_HOLES = true;
pocket_hole_d = 3.2;            // start with M3 clearance-ish; measure if possible
pocket_hole_y_spacing = 16;     // center-to-center between the two holes (measure!)
pocket_hole_x_inset = 0;        // 0 = centered in pocket width; + moves toward outside edge

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

  // Side pockets (shallow recesses)
  if (ENABLE_SIDE_POCKETS && pocket_depth > 0) {
    translate([-pocket_x_offset, 0, T - pocket_depth])
      cube([pocket_w, pocket_h, pocket_depth + 0.2], center = true);

    translate([ pocket_x_offset, 0, T - pocket_depth])
      cube([pocket_w, pocket_h, pocket_depth + 0.2], center = true);
  }

  // NEW: 2 holes per pocket (total 4), mirrored left/right
  if (ENABLE_POCKET_HOLES) {
    for (sx = [-1, 1]) {  // left/right
      for (sy = [-1, 1]) { // upper/lower
        translate([
          sx * pocket_x_offset + sx * pocket_hole_x_inset,
          sy * (pocket_hole_y_spacing/2),
          -0.5
        ])
        cylinder(h = T + 1, d = pocket_hole_d);
      }
    }
  }
}
