// Heart keychain — heart + fused top ring (one solid for printing)
// Units: mm

$fn = 96;

// ---- Body ----
T = 4;
scale_heart = 1.25;

// ---- Top ring ----
ring_outer_r = 5.5;
ring_inner_r = 3;      // slightly smaller helps keep side struts after hole cut

// Fraction of ring *diameter* (2*outer_r) that should overlap the heart downward (typ. 1/3)
ring_overlap_frac = 2/3;

// Hole center is shifted +Y so the cylinder does not eat the neck between heart and ring (see header comment)
hole_lift_y = 1.6;
// Extra nudge down if your preview still shows two bodies (e.g. -0.3 .. -0.8)
ring_cy_adjust = 0;

// Parametric heart (t in degrees)
function heart_xy(t) = [
  16 * pow(sin(t), 3),
  13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
];

function max_list(a, i = 0, m = -1e9) =
  i >= len(a) ? m : max_list(a, i + 1, max(m, a[i]));

steps = 160;
heart_pts = [ for (i = [0 : steps - 1])
  let (t = i * 360 / steps)
    heart_xy(t) * scale_heart
];

heart_y_max = max_list([for (p = heart_pts) p[1]]);
// Overlap depth along +Y into heart ≈ ring_overlap_frac * 2 * ring_outer_r
ring_cy = heart_y_max + ring_outer_r * (1 - 2 * ring_overlap_frac) + ring_cy_adjust;
hole_y = ring_cy + hole_lift_y;

difference() {
  linear_extrude(T, center = false)
    union() {
      polygon(heart_pts);
      translate([0, ring_cy])
        circle(r = ring_outer_r);
    }
  translate([0, hole_y, -0.01])
    cylinder(h = T + 0.02, r = ring_inner_r);
}
