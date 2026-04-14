// Hart-sleutelhanger — hart + samengevoegde bovenring (één massief voor printen)
// Eenheden: mm

$fn = 96;

// ---- Lichaam ----
T = 3;
scale_heart = 1.25;

// ---- Bovenring ----
ring_outer_r = 5.5;
ring_inner_r = 3;      // iets kleiner houdt zijdelingse steun na uitfrezen van het gat

// Fractie van de ring*diameter* (2*outer_r) die naar beneden over het hart moet vallen (typ. 1/3)
ring_overlap_frac = 3/4;

// Gatcentrum is in +Y verschoven zodat de cilinder de hals tussen hart en ring niet 'wegvreet' (zie koptekst)
hole_lift_y = 1.6;
// Extra duwtje naar beneden als de preview nog twee lichamen toont (bijv. -0,3 .. -0,8)
ring_cy_adjust = 0;

// Parametrisch hart (t in graden)
function heart_xy(t) = [
  16 * pow(sin(t), 3),
  13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
];

steps = 420;  // vloeiendere curve + minder slechte driehoeken in de bovenste inkeping
heart_pts = [ for (i = [0 : steps - 1])
  let (t = i * 360 / steps)
    heart_xy(t) * scale_heart
];

// Afgerond silhouet: offset(R) offset(-R) fillet hoeken zonder veel totale groei.
// Kleine extra buiten-offset sluit hardnekkige CSG-gaten in de diepe V (triangulatie).
heart_profile_round_r = 0.14;
heart_gap_fill_r = 0.08;

// Verticale rand: minkowski + bol rondt boven/onder af. Dit is ZEER zwaar in CGAL
// (lijkt vaak lang 'hangend'). Standaard uit — alleen 2D-offsets voor snelle preview.
// Als je dit aanzet, houd minkowski_sphere_fn laag (bijv. 16–24) en reken op trage F6/render.
edge_round_z = 0;
minkowski_sphere_fn = 20;
// Plaat-hoogte vóór minkowski (alleen bij edge_round_z > 0).
extrude_h_mink = max(0.2, T - 2 * edge_round_z);

heart_y_max = max([for (p = heart_pts) p[1]]);
// + heart_gap_fill_r: ring volgt lichte netto groei alleen door de buitenste gap-fill-offset.
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

difference() {
  if (edge_round_z > 0) {
    minkowski() {
      linear_extrude(extrude_h_mink, center = false, convexity = 10)
        heart_ring_profile();
      sphere(r = edge_round_z, $fn = minkowski_sphere_fn);
    }
  } else {
    linear_extrude(T, center = false, convexity = 10)
      heart_ring_profile();
  }
  translate([0, hole_y, -0.01])
    cylinder(
      h = T + (edge_round_z > 0 ? 2 * edge_round_z : 0) + 0.02,
      r = ring_inner_r
    );
}
