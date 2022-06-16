include <ikea_skadis.scad>

color(c = [0, 0, 1], alpha = 1) {
    skadis_rack(d1 = 16, d2 = 3.2, height=10, n = 4, compact=false);
}

//skadis_bits_serie(d = 8, facets = 6, n = 10, h = 20, compact = true, bottom=false);