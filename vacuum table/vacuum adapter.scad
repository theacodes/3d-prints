include <config.scad>
include <common.scad>
use <box.scad>

module vacuum_adapter() {
    hose_id =  34.6;
    adapter_length = 20;
    adapter_offset = 10;

    color("LightCoral") {
        linear_extrude(adapter_length) {
            difference() {
                circle(d=hose_id);
                circle(d=hose_id - 3);
            }
        }
        linear_extrude(3) {
            difference() {
                hull() {
                    offset(r = 5) __vacuum_hole_outline();
                    circle(d=hose_id);
                }
                __vacuum_hole_outline();
            }
        }
    }
}

vacuum_adapter();
