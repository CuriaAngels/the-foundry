// Engine mount plate v2 — simplified: rounded body + holes only (no pockets)
// Units: mm

$fn = 96;

// ---- Main parameters (known) ----
W = 75;          // overall width
H = 48;          // overall height
T = 4;           // thickness
R = 12;          // corner radius

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

  // Through-holes only
  for (h = holes)
    translate([h[0], h[1], -0.5])
      cylinder(h = T + 1, d = h[2]);
}
