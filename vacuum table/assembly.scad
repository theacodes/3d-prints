include <config.scad>
use <box.scad>
use <lid.scad>
use <riser.scad>
use <adjustable riser.scad>
use <vacuum adapter.scad>

box();

translate([box_size.x / 2, 0, box_size.z / 2]) {
    rotate([90, 0, 0]) {
        vacuum_adapter();
    }
}

translate([0, 0, box_size.z]) {
    lid_3d();
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
