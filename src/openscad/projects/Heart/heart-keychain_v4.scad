// Heart keychain v4 — "Thank You" (two lines) debossed on the heart, 1 mm default depth
// Based on heart-keychain.scad
// Units: mm

$fn = 96;

// =============================================================================
// QUICK TUNING — change these first
// =============================================================================
//
// Heart shape (overall size is scale × built-in curve)
scale_heart = 1.25;

// Plate thickness (Z height of the flat body)
T = 3;

// Key ring (hole is cut through the tab; tab overlaps the heart top)
ring_outer_r = 5.5;       // outside radius of the ring tab
ring_inner_r = 3;       // hole radius for the split ring
ring_overlap_frac = 3/4; // how far the ring disk overlaps the heart (see ring_cy below)
hole_lift_y = 1.6;        // shifts hole center in +Y so the cut does not eat the neck
ring_cy_adjust = 0;       // fine-tune ring position if preview looks off

// Text — "Thank" and "You" (two lines), cut into the top face
text_deboss = 1;              // how deep the letters go into the part (mm)
line_center_gap = 1.2;        // distance between the two line centers, in units of text size (larger = more line spacing)
text_fill_fraction = 4/ 5; // target: text block fits inside this fraction of the smaller heart span (width vs height)
thank_width_factor = 5.2;     // width of the word "Thank" ≈ this × text_size (tune if you change font/weight)
// Where the text sits vertically on the heart (only the heart polygon, not the ring):
//   0 = bottom tip (min Y), 1 = top of heart bbox (max Y). ~0.5 = middle.
text_vertical_pos = 0.6;

text_font = "Liberation Sans:style=Bold";

// Silhouette smoothing (small offsets on the 2D heart outline)
heart_profile_round_r = 0.14;
heart_gap_fill_r = 0.08;

// Optional: vertical edge round (expensive CGAL); 0 = flat extrusion only
edge_round_z = 0;
minkowski_sphere_fn = 20;

// Preview-only colors (F5/F6 — helps tell heart vs ring apart; STL export stays one solid)
color_heart = "#e91e63";   // heart silhouette
color_ring = "#5c6bc0";    // upper key ring tab

// =============================================================================
// Heart curve and derived sizes (usually leave alone)
// =============================================================================

function heart_xy(t) = [
  16 * pow(sin(t), 3),
  13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
];

steps = 420;
heart_pts = [ for (i = [0 : steps - 1])
  let (t = i * 360 / steps)
    heart_xy(t) * scale_heart
];

extrude_h_mink = max(0.2, T - 2 * edge_round_z);

heart_x_min = min([for (p = heart_pts) p[0]]);
heart_x_max = max([for (p = heart_pts) p[0]]);
heart_y_min = min([for (p = heart_pts) p[1]]);
heart_y_max = max([for (p = heart_pts) p[1]]);
heart_width = heart_x_max - heart_x_min;
heart_height = heart_y_max - heart_y_min;

heart_size = min(heart_width, heart_height);
two_line_height_factor = line_center_gap + 1;
text_size_from_height = (heart_size * text_fill_fraction) / two_line_height_factor;
text_size_from_width = (heart_size * text_fill_fraction) / thank_width_factor;
text_size = min(text_size_from_height, text_size_from_width);

text_center_y = heart_y_min + heart_height * text_vertical_pos;

ring_cy = heart_y_max + heart_gap_fill_r
  + ring_outer_r * (1 - 2 * ring_overlap_frac) + ring_cy_adjust;
hole_y = ring_cy + hole_lift_y;

module heart_silhouette_profile() {
  offset(r = heart_gap_fill_r)
    offset(r = heart_profile_round_r)
      offset(r = -heart_profile_round_r)
        polygon(heart_pts);
}

module ring_tab_profile() {
  translate([0, ring_cy])
    circle(r = ring_outer_r);
}

module thank_you_2d() {
  union() {
    translate([0, line_center_gap * text_size / 2, 0])
      text(
        "Thank",
        size = text_size,
        halign = "center",
        valign = "center",
        font = text_font
      );
    translate([0, -line_center_gap * text_size / 2, 0])
      text(
        "You",
        size = text_size,
        halign = "center",
        valign = "center",
        font = text_font
      );
  }
}

difference() {
  if (edge_round_z > 0) {
    union() {
      color(color_heart)
        minkowski() {
          linear_extrude(extrude_h_mink, center = false, convexity = 10)
            heart_silhouette_profile();
          sphere(r = edge_round_z, $fn = minkowski_sphere_fn);
        }
      color(color_ring)
        minkowski() {
          linear_extrude(extrude_h_mink, center = false, convexity = 10)
            ring_tab_profile();
          sphere(r = edge_round_z, $fn = minkowski_sphere_fn);
        }
    }
  } else {
    union() {
      color(color_heart)
        linear_extrude(T, center = false, convexity = 10)
          heart_silhouette_profile();
      color(color_ring)
        linear_extrude(T, center = false, convexity = 10)
          ring_tab_profile();
    }
  }

  translate([0, hole_y, -0.01])
    cylinder(
      h = T + (edge_round_z > 0 ? 2 * edge_round_z : 0) + 0.02,
      r = ring_inner_r
    );

  translate([0, text_center_y, T - text_deboss])
    linear_extrude(height = text_deboss + 0.02, convexity = 10)
      thank_you_2d();
}
