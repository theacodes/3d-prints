include <config.scad>
include <common.scad>


module __box_outline(size) {
    size = size == undef ? box_size : size;
    __fillet(r=fillet_radius) {
         square([size.x, size.y]);
    }
}


module __bolt_holes_outline(d, size) {
    size = size == undef ? box_size : size;
    translate([screw_post_inset, screw_post_inset]) {
        circle(d = d);
    }
    translate([size.x - screw_post_inset, screw_post_inset]) {
        circle(d = d);
    }
    translate([size.x - screw_post_inset, size.y - screw_post_inset]) {
        circle(d = d);
    }
    translate([screw_post_inset, size.y - screw_post_inset]) {
        circle(d = d);
    }
}

module __vacuum_hole_bolts_outline() {
    spacing = vacuum_hole_diameter * 0.6;
    screw_spacing = spacing + vacuum_hole_diameter / 2 + bolt_head_clearance / 2 + 2;

    translate([screw_spacing, 0, 0]) {
        circle(d = bolt_diameter);
    }
    translate([-screw_spacing, 0, 0]) {
        circle(d = bolt_diameter);
    }
}

module __vacuum_hole_outline() {
    spacing = vacuum_hole_diameter * 0.6;

    hull() {
        translate([-spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
        translate([spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
    }

    __vacuum_hole_bolts_outline();
}

module __vacuum_hole() {
    translate([box_size.x / 2, 0, box_size.z / 2]) {
        rotate([90, 0, 0]) {
            linear_extrude(wall_thickness * 2 + 0.04, center=true) {
                __vacuum_hole_outline();
            }
        }
    }
}

module __vacuum_holes() {
    __vacuum_hole();
    translate([0, box_size.y]) __vacuum_hole();
    rotate([0, 0, 90]) __vacuum_hole();
    translate([box_size.x, 0]) rotate([0, 0, 90]) __vacuum_hole();
}

module box() {
    color("MediumPurple") {
        difference() {
            union() {
                difference() {
                    // Box
                    linear_extrude(box_size.z) {
                        __box_outline();
                    }
                    // Inner void
                    translate([0, 0, floor_thickness]) {
                        linear_extrude(box_size.z) {
                            offset(r = -wall_thickness) {
                                __box_outline();
                            }
                        }
                    }
                    // Vacuum holes
                    __vacuum_holes();
                }

                // Screw posts
                linear_extrude(box_size.z) {
                    __bolt_holes_outline(screw_post_diameter);
                }
            }

            // Screw holes
            translate([0, 0, -0.02]) {
                linear_extrude(box_size.z + 0.04) {
                    difference() {
                        __bolt_holes_outline(bolt_diameter);
                    }
                }
                linear_extrude(nut_height) {
                    difference() {
                        __bolt_holes_outline(nut_diameter);
                    }
                }
            }
        }
    }
}

box();
