// Kat-silhouet naar voorbeeld (reik / zittend, vooraanzicht)
// 150 mm hoogte, 10 mm dikte (extrusie). Zie cat-reaching-reference.png naast dit bestand.
// Eenheden: mm

$fn = 96;

// Totale hoogte (poot / grond → top van opgestoken poot)
H = 150;
// Horizontaal: breedte schaalt mee (beeld ~ hoger dan breed, incl. staart)
W = 88;

// Dikte in extruderichting (Z) — "1 cm" uit je omschrijving
T = 10;

profile_round_r = 0.35;

// Genormaliseerde polygon [0–1]×[0–1] : x links→rechts, y onder→boven. Contour CCW.
cat_pts_norm = [
  // Staart — J-vorm, linksonpen
  [0.00, 0.28],
  [0.02, 0.36],
  [0.04, 0.46],
  [0.08, 0.56],
  [0.13, 0.64],
  [0.18, 0.71],
  // Linker rug / schouder richting opgestoken voorpoot (buitenkant)
  [0.16, 0.76],
  [0.14, 0.82],
  [0.11, 0.88],
  [0.09, 0.93],
  [0.10, 0.985],
  [0.12, 1.00],
  [0.15, 0.995],
  [0.14, 0.94],
  [0.13, 0.88],
  [0.14, 0.80],
  [0.18, 0.74],
  // Nek / achterkop naar oren
  [0.28, 0.78],
  [0.34, 0.82],
  [0.40, 0.87],
  [0.44, 0.93],
  [0.48, 0.97],
  [0.52, 0.995],
  [0.58, 0.97],
  [0.62, 0.92],
  [0.64, 0.86],
  [0.62, 0.78],
  [0.58, 0.72],
  // Rechterzijde borst / nek naar dragend voorbeen
  [0.68, 0.68],
  [0.74, 0.58],
  [0.80, 0.46],
  [0.84, 0.34],
  [0.88, 0.22],
  [0.90, 0.10],
  [0.91, 0.00],
  // Onderkant — zitvlak + rechter voorpoot
  [0.84, 0.00],
  [0.72, 0.00],
  [0.58, 0.00],
  [0.44, 0.00],
  [0.32, 0.00],
  [0.22, 0.00],
  [0.14, 0.00],
  [0.08, 0.02],
  [0.04, 0.06],
  [0.02, 0.12],
  [0.00, 0.20],
];

cat_pts = [ for (p = cat_pts_norm) [ p[0] * W, p[1] * H ] ];

module cat_profile_2d() {
  offset(r = profile_round_r)
    offset(r = -profile_round_r)
      polygon(cat_pts);
}

linear_extrude(T, center = false, convexity = 10)
  cat_profile_2d();
