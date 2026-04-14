// Heart keychain v3 - zelfde als heart-keychain.scad, met lichte afronding alleen aan de BOVENkant
// (buitenrand boven/zijkant minder scherp). Onderkant en onderste zijkant blijven scherp 90°.
// Units: mm

$fn = 96;

// Zelfde default als heart-keychain.scad; verhoog naar bv. 4 voor dikkere tag
T = 2;

scale_heart = 1.25;

// ---- Top ring ----
ring_outer_r = 5.5;
ring_inner_r = 3;

ring_overlap_frac = 3/4;
hole_lift_y = 1.6;
ring_cy_adjust = 0;

function heart_xy(t) = [
  16 * pow(sin(t), 3),
  13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
];

steps = 420;
heart_pts = [ for (i = [0 : steps - 1])
  let (t = i * 360 / steps)
    heart_xy(t) * scale_heart
];

heart_profile_round_r = 0.14;
heart_gap_fill_r = 0.08;

// Afronding alleen boven: hull van vol profiel (op hoogte T-cz) naar iets kleiner profiel op T.
// Negatieve offset moet klein blijven (enge inkeping hart) anders stukgedeeld profiel.
TOP_BEVEL_ANGLE_DEG = 42;
TOP_BEVEL_DEPTH = 0.35;      // mm langs Z, reservering vanaf de bovenkant
MAX_TOP_INSET_MM = 0.2;

heart_y_max = max([for (p = heart_pts) p[1]]);
ring_cy = heart_y_max + heart_gap_fill_r
  + ring_outer_r * (1 - 2 * ring_overlap_frac) + ring_cy_adjust;
hole_y = ring_cy + hole_lift_y;

module heart_ring_profile() {
  union() {
    offset(r = heart_gap_fill_r)
      offset(r = heart_profile_round_r)
        offset(r = -heart_profile_round_r)
          polygon(heart_pts);
    translate([0, ring_cy])
      circle(r = ring_outer_r);
  }
}

// Basis: één blok met scherpe onderkant + scherpe zijkant tot z=T-cz; alleen de laag onder de top wordt schuin/afgerond.
module body_with_top_bevel_only(height, bevel_z, angle_deg, max_inset) {
  a = max(0.5, angle_deg);
  cz_unclamped = min(max(0, bevel_z), height - 0.15);
  inset_raw = cz_unclamped / tan(a);
  inset = min(inset_raw, max_inset);
  cz = min(inset * tan(a), cz_unclamped);
  eps = 0.02;
  if (cz < 0.01) {
    linear_extrude(height, center = false, convexity = 10)
      heart_ring_profile();
  } else {
    union() {
      linear_extrude(height - cz, center = false, convexity = 10)
        heart_ring_profile();
      hull() {
        translate([0, 0, height - cz])
          linear_extrude(eps, center = false)
            heart_ring_profile();
        translate([0, 0, height])
          linear_extrude(eps, center = false)
            offset(r = -inset, join_type = "round")
              heart_ring_profile();
      }
    }
  }
}

difference() {
  body_with_top_bevel_only(T, TOP_BEVEL_DEPTH, TOP_BEVEL_ANGLE_DEG, MAX_TOP_INSET_MM);
  translate([0, hole_y, -0.01])
    cylinder(h = T + 0.02, r = ring_inner_r);
}
