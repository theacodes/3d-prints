include <config.scad>
include <common.scad>
use <box.scad>
use <vacuum seal.scad>

module vacuum_adapter() {
    hose_id =  13.5;
    adapter_length = 20;

    color("LightCoral") {
        difference() {
            union() {
                translate([0, 0, -adapter_length]) {
                    linear_extrude(adapter_length) {
                        circle(d=hose_id);
                    }
                }
                vacuum_seal();
            }
            
            translate([0, 0, -adapter_length - 0.02]) {
                linear_extrude(adapter_length + 10) {
                    circle(d=hose_id - 3);
                }
            }
        }
    }
}

vacuum_adapter();
