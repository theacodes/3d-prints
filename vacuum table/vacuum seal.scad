include <config.scad>
use <box.scad>


module __vacuum_seal_slot(spacing) {
    hull() {
        translate([-spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
        translate([spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
    }
}

module __vacuum_seal_outline(spacing) {
    screw_spacing = spacing + vacuum_hole_diameter / 2 + bolt_head_clearance / 2 + 2;
    difference() {
        hull() {
            offset(2) {
                __vacuum_hole_outline();
            }
        }
        translate([screw_spacing, 0, 0]) {
            circle(d = bolt_diameter - 0.02);
        }
        translate([-screw_spacing, 0, 0]) {
            circle(d = bolt_diameter - 0.02);
        }
    }
}


module vacuum_seal() {
    spacing = vacuum_hole_diameter * 0.6;

    
    difference() {
        linear_extrude(1.5) {
            __vacuum_seal_outline(spacing);
        }
    }
    
    difference() {
        linear_extrude(3) {
            offset(-0.5) {
                __vacuum_seal_slot(spacing);
            }
        }
        linear_extrude(3 + 0.02) {
            offset(-1.5) {
                __vacuum_seal_slot(spacing);
            }
        }
    }
}

vacuum_seal();