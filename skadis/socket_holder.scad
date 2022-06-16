include <ikea_skadis.scad>

/* Screw driver holder hole can be define with either one or two diameter:
 * 1. default and unique considered diameter
 * 2. diameter 1 for the handle
 * 3. diameter 2 for the shank or blade
 */
module skadis_driver_hole(d, d1, d2, height = pw) {
    if (d == undef) {
        union() {
            translate([0, 0, height]) {
                cylinder(h = chamfer() + 0.01, d1 = d2, d2 = d2-2*chamfer());
            }
            /*translate([0, 0, height-(floor(pw/2/lh)*lh)]) {
                cylinder(h = lh / 2 + 0.01, d = d1);
            }*/
            cylinder(h = height + 0.01, d = d2);
        }
    }
}

module skadis_rack(d, d1 = 20, d2 = 10, n = 6, compact = false, all_pegs = all_pegs, fullfill = fullfill, retainer = retainer, height = pw) {

    function rack_length() = (n*(d1+pw))+pw;
   
    union() {
        union() {
            hull() {
                translate([0, -pw/2, height/2]) {
                    cube(size = [rack_length(), pw, height], center = true);
                }
                for (x = [0:1:1]) mirror([x, 0, 0]) {
                    translate(
                        [(d == undef) ? (rack_length()-(d1+2*pw))/2 : (rack_length()-(d+2*pw))/2,
                        (compact) ?
                            (d == undef) ?
                                -(2*pw+d1/2+(d1+pw)/2*sqrt(3)) :
                                -(2*pw+d/2+(d+pw)/2*sqrt(3)) :
                                (d == undef)?-(2*pw+d1/2):-(2*pw+d/2),
                        0]
                    ) {
                        cylinder(h = height, d = ((d == undef) ? d1+2*pw : d+2*pw));
                    }
                }
            }
            translate(
                [(compact) ?
                    ((d == undef) ? -((n-1)*(d1+pw)/4) : -((n-1)*(d+pw)/4)) :
                    ((d == undef) ? -((n-1)*(d1+pw)/2) : -((n-1)*(d+pw)/2)),
                (d == undef) ? -(d1/2+2*pw) : -(d/2+2*pw),
                0]
            ) {
                    for (x = [0:1:n-1]) {
                        translate([x*(d1+pw), 0, 0]) {
                            skadis_driver_hole(d = d, d1 = d1, d2 = d2[x], height = height + 5);
                        }
                    }
            }
        }
        skadis_pegs_position(length = rack_length()-pt, all_pegs = all_pegs) skadis_peg(fullfill = fullfill, retainer = retainer);
    }
}

color(c = [0, 0, 1], alpha = 1) {
    skadis_rack(d1 = 16, d2 = [6, 6, 6, 6], height=pw, n = 4, compact=false);
}