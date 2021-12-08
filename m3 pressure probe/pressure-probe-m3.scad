$fn = 50;
height = 18;

taper_height = 8;
hole_diameter = 3.4;
insert_diameter = 4.6;
insert_height = 5.7;
outer_diameter = insert_diameter + 1;
fin_width = outer_diameter + 8;
fin_thickness = 2;
fin_offset = 2;

module buffer_extrude(depth, buffer=0.5) {
    translate([0, 0, -buffer]) {
        linear_extrude(depth+buffer*2) {
            children();
        }
    }
}

module screw_hole(x, y, depth, d ) {
    buffer_extrude(depth, 0.5) {
        circle(d=d);
    }
}



difference() {
    union() {
        linear_extrude(height - taper_height) {
            circle(d=outer_diameter);
        }
        translate([0, 0, height - taper_height]) {
            linear_extrude(taper_height, scale=0.5) {
                circle(d=outer_diameter);
            }
        }
        translate([0, 0, height]) {
            sphere(d = outer_diameter / 2);
        }
    }
    screw_hole(0, 0, height - taper_height, hole_diameter);
    screw_hole(0, 0, , insert_height, insert_diameter - 0.2);
}