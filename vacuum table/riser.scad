include <config.scad>
include <common.scad>
use <lid.scad>


module __riser_pegs_outline(pos, size, d) {
    translate(pos + [lid_hole_spacing / 2, lid_hole_spacing / 2]){
        circle(d = d);
    }
    translate(pos + size - [lid_hole_spacing / 2, lid_hole_spacing / 2]){
        circle(d = d);
    }
}

module riser() {
    size = [lid_hole_spacing * 3, lid_hole_spacing * 3];
    pos = [lid_hole_border + lid_hole_spacing / 2, lid_hole_border + lid_hole_spacing / 2];
    margin = [0.5, 0.5];

    color("HotPink") {
        translate(-(pos + margin)) {
            linear_extrude(pcb_size.z) {
                difference() {
                    translate(pos + margin) {
                        __fillet(lid_hole_diameter) {
                            square(size - margin);
                        }
                    }
                    __lid_holes();
                }
            }
            difference() {
                union() {
                    linear_extrude(lid_thickness + pcb_size.z) {
                    __riser_pegs_outline(pos=pos, size=size, d=lid_hole_diameter - 0.02);
                    }
                    linear_extrude(pcb_size.z) {
                        __riser_pegs_outline(pos=pos, size=size, d=lid_hole_diameter + 0.03);
                    }
                }
                linear_extrude(lid_thickness + pcb_size.z + 0.02) {
                    __riser_pegs_outline(pos=pos, size=size, d=lid_hole_diameter / 2);
                }
            }
        }
    }
}

riser();
