include <config.scad>
include <common.scad>

hinge_width = 25;
hinge_length = 20;
hinge_diameter = bolt_head_clearance + 0.5;
hinge_bolt_diameter = 3.5;
hinge_lower_leaf_height = 0.6;
hinge_split_count = 6;
stencil_slot_height = 1;

hinge_mounting_hole_offset = hinge_diameter + 1;
hinge_mounting_hole_offset_2 = bolt_head_clearance;
hinge_upper_leaf_height = hinge_diameter - hinge_lower_leaf_height;
hinge_split_width = hinge_width / hinge_split_count;


module __hinge() {
    translate([0, 0, hinge_diameter / 2]) {
        rotate([0, 90, 0]) {
            linear_extrude(hinge_width) {
                circle(d=hinge_diameter);
            }
        }
    }
}

module __hinge_rod_hole() {
    translate([-0.02, 0, hinge_diameter / 2]) {
        rotate([0, 90, 0]) {
            linear_extrude(hinge_width + 0.04) {
                circle(d=hinge_bolt_diameter);
            }
        }
    }
}

module __hinge_splits(start) {
    translate([0, -hinge_diameter/2, 0]) {
        union() {
            for(n = [start:2:hinge_split_count - 1]) {
                translate([(hinge_split_width + 0.05) * n, 0]) {
                    cube([hinge_split_width - 0.1, hinge_diameter, hinge_diameter]);
                }
            }
        }
    }
}

module __leaf_mounting_holes_outline(d) {
    center = hinge_width / 2;
    translate([center + screw_post_inset, hinge_mounting_hole_offset]) {
        circle(d = d);
    }
    translate([center - screw_post_inset, hinge_mounting_hole_offset]) {
        circle(d = d);
    }
}

module lower_leaf() {
    difference() {
        union() {
            linear_extrude(hinge_lower_leaf_height) {
                difference() {
                    square([hinge_width, hinge_length]);
                    __leaf_mounting_holes_outline(d=bolt_diameter - 0.05);
                }
            }
            intersection() {
                __hinge();
                __hinge_splits(0);
            }
        }
        __hinge_rod_hole();
    }
}

module upper_leaf() {
    color("blue") {
        difference() {
            union() {
                translate([0, 0, hinge_lower_leaf_height]) {
                    linear_extrude(hinge_upper_leaf_height) {
                        difference() {
                            square([hinge_width, hinge_length]);
                            __leaf_mounting_holes_outline(d=bolt_head_clearance);
                        }
                    }
                }
                intersection() {
                    __hinge();
                    __hinge_splits(1);
                }
            }
            translate([-0.02, hinge_mounting_hole_offset + bolt_head_clearance / 2, pcb_size.z]) {
                linear_extrude(stencil_slot_height) {
                    square(hinge_width + 0.02);
                }
            }
            translate([0, hinge_mounting_hole_offset_2, hinge_lower_leaf_height + stencil_slot_height - 0.02]) {
                linear_extrude(10) {
                    __leaf_mounting_holes_outline(bolt_diameter - 0.05);
                }
            }
            __hinge_rod_hole();
        }
    }
}

//lower_leaf();
upper_leaf();