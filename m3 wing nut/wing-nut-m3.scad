$fn = 50;
hole_diameter = 3.3;
insert_diameter = 4.6;
insert_height = 5.7;

outer_diameter=hole_diameter + 3;
height = insert_height + 1.5;
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

module fins() {
    rotate([-90, 0, 0]){
        translate([0, -fin_width / 2, -fin_thickness / 2]){
            difference() {
                linear_extrude(fin_thickness) {
                    difference() {
                        circle(d=fin_width);
                        translate([0, -fin_width / 2 - fin_offset, 0]){
                            square([fin_width, fin_width], true);
                        }
                    }
                }
                translate([0, -(fin_width/4) + 1, 0]) {
                    buffer_extrude(fin_thickness) {
                        circle(d=fin_width/2);
                    }
                }
            }
        }
    }
}



difference() {
    union() {
        linear_extrude(height) {
            circle(d=outer_diameter);
        }
        fins();
    }
    screw_hole(0, 0, height + 10, hole_diameter);
    screw_hole(0, 0, , insert_height, insert_diameter - 0.2);
}