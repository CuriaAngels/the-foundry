// Heart keychain v2 — 4 cm grootte, 5 mm dikte, gat voor sleutelring
// (Zelfde opbouw als heart-keychain.scad; apart bestand zodat v1 intact blijft.)
// Units: mm

// In preview lager = sneller; F6 gebruikt volle kwaliteit
$fn = $preview ? 48 : 96;

// ---- Afmetingen (voorbeeld) ----
TARGET_BODY_MM = 40;   // grootste zijde van het hart (bounding box vóór offsets)
T = 5;                 // 0,5 cm dikte

// ---- Bovenring (één stuk met het hart) ----
ring_outer_r = 6;
ring_inner_r = 4;      // gat Ø ≈ 8 mm — ruim genoeg voor veel split-ringen

ring_overlap_frac = 2/3;
hole_lift_y = 1.8;
ring_cy_adjust = 0;

// Parametrische hartcurve (t in graden)
function heart_xy(t) = [
  16 * pow(sin(t), 3),
  13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
];

steps = 420;
heart_pts_unit = [ for (i = [0 : steps - 1])
  let (t = i * 360 / steps)
    heart_xy(t)
];

min_x = min([for (p = heart_pts_unit) p[0]]);
max_x = max([for (p = heart_pts_unit) p[0]]);
min_y = min([for (p = heart_pts_unit) p[1]]);
max_y = max([for (p = heart_pts_unit) p[1]]);
bbox_w = max_x - min_x;
bbox_h = max_y - min_y;
scale_heart = TARGET_BODY_MM / max(bbox_w, bbox_h);

heart_pts = [ for (p = heart_pts_unit) p * scale_heart ];

heart_profile_round_r = 0.12 * (TARGET_BODY_MM / 40);
heart_gap_fill_r = 0.06 * (TARGET_BODY_MM / 40);

// Facet op boven- en onderrand (geen 90° hoek meer). Hoek = t.o.v. het horizontale vlak (boven/onder).
// Steiler facet → kleinere hoek in graden. inset = diepte / tan(hoek).
CHAMFER_ANGLE_DEG = 30;
CHAMFER_DEPTH = 1.0;   // mm langs Z; hou kleiner dan ~T/2

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

// Boven/onder: hull tussen vol profiel en licht ingesprongen profiel = rechte facet (chamfer).
module body_with_edge_chamfer(height, chamfer_z, angle_deg) {
  cz = min(max(0, chamfer_z), height / 2 - 0.05);
  a = max(0.5, angle_deg);
  inset = cz / tan(a);
  eps = 0.02;
  if (cz < 0.01) {
    linear_extrude(height, center = false, convexity = 10)
      heart_ring_profile();
  } else {
    union() {
      hull() {
        linear_extrude(eps, center = false)
          heart_ring_profile();
        translate([0, 0, cz])
          linear_extrude(eps, center = false)
            offset(r = -inset, join_type = "round")
              heart_ring_profile();
      }
      translate([0, 0, cz])
        linear_extrude(height - 2 * cz, center = false, convexity = 10)
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
  body_with_edge_chamfer(T, CHAMFER_DEPTH, CHAMFER_ANGLE_DEG);
  translate([0, hole_y, -0.01])
    cylinder(h = T + 0.02, r = ring_inner_r);
}
