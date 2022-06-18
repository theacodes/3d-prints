include <config.scad>
use <box.scad>
use <lid.scad>
use <riser.scad>
use <adjustable riser.scad>
use <vacuum adapter.scad>
use <vacuum seal.scad>

box($fn=10);
translate([box_size.x, 0]) {
    box($fn=10);
}

translate([box_size.x / 2, -2, box_size.z / 2]) {
    rotate([270, 0, 0]) {
        vacuum_seal($fn=10);
    }
}

translate([box_size.x * 1.5, 0, box_size.z / 2]) {
    rotate([90, 0, 0]) {
        vacuum_adapter($fn=20);
    }
}

translate([0, 0, box_size.z]) {
    lid_3d($fn=10);
}

translate([
        (lid_hole_spacing * 3.5) + 0.5,
        (lid_hole_spacing * 4.5) - 0.5,
        box_size.z + lid_thickness + pcb_size.z]) {
    rotate([180, 0, 0]) {
        riser();
    }
}

translate([
        (lid_hole_spacing * 5.5) + 0.5,
        (lid_hole_spacing * 4.5) - 0.5,
        box_size.z + lid_thickness + pcb_size.z]) {
    rotate([0, 0, 0]) {
        adjustable_riser();
        adjustable_riser_peg();
    }
}
