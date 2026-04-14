// Kubus met aan elke zijde een vierkante opening (1×1 cm) die doorloopt tot de tegenoverliggende zijde.
// Drie tunnels (X, Y, Z) kruisen in het midden. Buitenhoeken zijn afgerond (Minkowski).
// Tunnelprofiel: afgeronde vierkante doorsnede — vloekt de binnenhoeken in het middenstuk.
// Units: mm (5 cm = 50 mm, 1 cm = 10 mm)

cube_side = 50;   // 5 cm
opening = 10;     // 1 cm — zijde van het vierkant in de wand
tunnel_eps = 0.5; // iets langer dan de kubus voor schone CSG-booleans

// Afronding buitenhoeken / randen (Minkowski: kubus + bol). Te groot t.o.v. cube_side geeft domeinenfout.
corner_r = 2.5;
corner_fn = 32;   // aparte $fn voor de bol — Minkowski is zwaar; verlagen voor snellere F6

// Hoekradius binnenin het tunnelprofiel (vierkant 1×1 cm). Houd < opening/2 (bijv. max ~4 bij opening 10).
tunnel_fillet_r = 1.5;

$fn = 64;

module rounded_cube() {
  minkowski() {
    cube(cube_side - 2 * corner_r, center = true);
    sphere(corner_r, $fn = corner_fn);
  }
}

// Afgeronde vierkante doorsnede (dubbele offset) voor de tunnel langs de hele lengte.
module tunnel_profile_2d() {
  offset(r = tunnel_fillet_r)
    offset(r = -tunnel_fillet_r)
      square(opening, center = true);
}

module tunnel_along_x() {
  rotate([0, 90, 0])
    linear_extrude(cube_side + tunnel_eps, center = true, convexity = 4)
      tunnel_profile_2d();
}

module tunnel_along_y() {
  rotate([90, 0, 0])
    linear_extrude(cube_side + tunnel_eps, center = true, convexity = 4)
      tunnel_profile_2d();
}

module tunnel_along_z() {
  linear_extrude(cube_side + tunnel_eps, center = true, convexity = 4)
    tunnel_profile_2d();
}

difference() {
  rounded_cube();
  tunnel_along_x();
  tunnel_along_y();
  tunnel_along_z();
}
