include <config.scad>
use <box.scad>
use <vacuum seal.scad>
use <threads.scad>

module vacuum_release_plate() {
    spacing = vacuum_hole_diameter * 0.6;
    color("Orange") {
        ScrewHole(8, 10) {
            linear_extrude(1.5) {
                __vacuum_seal_outline(spacing);
            }
            linear_extrude(5) {
                circle(d=11);
            }
        }
    }
}

module vacuum_release_bolt() {
    color("Green") {
        difference() {
            ScrewThread(9, 15);
            translate([0, 0, 5]) {
                linear_extrude(10 + 0.02) {
                    circle(d=5);
                }
            }
            translate([4, 0, 6]) {
                linear_extrude(10 + 0.02) {
                    circle(d=5);
                }
            }
        }
        linear_extrude(4) {
            union() {
                for(n = [0:12]) {
                    rotate([0, 0, 360 / 12 * n]) {
                        translate([6, 0]) {
                            circle(d = 5);
                        }
                    }
                }
                circle(d = 10);
            }
        }
    }
}

module vacuum_release() {
    vacuum_release_plate();
    translate([0, 0, -8]) {
        vacuum_release_bolt();
    }
}

vacuum_release();