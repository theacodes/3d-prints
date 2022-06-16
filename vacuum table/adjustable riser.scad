include <config.scad>
include <common.scad>

module adjustable_riser() {
    color("HotPink") {
        difference() {
            linear_extrude(pcb_size.z) {
                __fillet(2) {
                    square([lid_hole_spacing, lid_hole_spacing * 4]);
                }
            }
            translate([lid_hole_spacing / 2, lid_hole_spacing / 2, -0.02]) {
                linear_extrude(pcb_size.z + 0.04) {
                    hull() {
                        circle(d=lid_hole_diameter);
                        translate([0, lid_hole_spacing * 3]) circle(d=lid_hole_diameter);
                    }
                }
            }
            translate([lid_hole_spacing / 2, lid_hole_spacing / 2, pcb_size.z - 1]) {
                linear_extrude(pcb_size) {
                    hull() {
                        circle(d=lid_hole_diameter + 3);
                        translate([0, lid_hole_spacing * 3]) circle(d=lid_hole_diameter + 3);
                    }
                }
            }
        }
    }
}

module adjustable_riser_peg() {
    color("PeachPuff", 0.9) {
        translate([lid_hole_spacing / 2, lid_hole_spacing, pcb_size.z]) {
            rotate([180, 0, 0]) {
                linear_extrude(0.95) {
                    circle(d=lid_hole_diameter + 3 - 0.1);
                }
                linear_extrude(lid_thickness) {
                    circle(d=lid_hole_diameter - 0.03);
                }
                translate([0, 0, lid_thickness]) {
                    linear_extrude(1, scale=0.3) {
                        circle(d=lid_hole_diameter - 0.03);
                    }
                }
            }
        }
    }
}

adjustable_riser();
adjustable_riser_peg();
