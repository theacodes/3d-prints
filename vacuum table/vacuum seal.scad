include <config.scad>
use <box.scad>


module __vacuum_seal_slot() {
    spacing = vacuum_hole_diameter * 0.6;
    hull() {
        translate([-spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
        translate([spacing, 0, 0]) {
            circle(d = vacuum_hole_diameter);
        }
    }
}

module __vacuum_seal_outline() {
    spacing = vacuum_hole_diameter * 0.6;
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

module __vacuum_seal_lip() {
    spacing = vacuum_hole_diameter * 0.6;
    
    linear_extrude(3) {
        difference() {
            offset(-0.8) {
                __vacuum_seal_slot();
            }
            offset(-1.5) {
                __vacuum_seal_slot();
            }
            
        }
    }
}


module vacuum_seal() {
    linear_extrude(1.5) {
        __vacuum_seal_outline();
    }
    
    __vacuum_seal_lip();
}

vacuum_seal();