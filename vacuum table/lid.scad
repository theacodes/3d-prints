include <config.scad>
include <common.scad>
use <box.scad>

module __lid_bolt_holes_outline(d, size, box_size) {
    box_count_x = size.x / box_size.x;
    /* Top and bottom holes */
    for(xn = [0:box_count_x]) {
        box_offset = [xn * box_size.x, 0];
        translate(box_offset + [screw_post_inset, screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [box_size.x - screw_post_inset, screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [box_size.x - screw_post_inset, size.y - screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [screw_post_inset, size.y - screw_post_inset]) {
            circle(d = d);
        }
    }
    /* Left and right holes */
    box_count_y = size.y / box_size.y;
    for(yn = [0:box_count_y]) {
        box_offset = [0, yn * box_size.y];
        translate(box_offset + [screw_post_inset, screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [screw_post_inset, box_size.y - screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [size.x - screw_post_inset, screw_post_inset]) {
            circle(d = d);
        }
        translate(box_offset + [size.x - screw_post_inset, box_size.y - screw_post_inset]) {
            circle(d = d);
        }
    }
}


module __lid_holes(size, border) {
    size = size == undef ? lid_size : size;
    border = border == undef ? lid_hole_border : border;

    for(xn = [0:lid_hole_spacing:size.x]) {
        if(xn > border && xn < size.x - border) {
            for(yn = [0:lid_hole_spacing:size.y]) {
                if(yn > border && yn < size.y - border) {
                    translate([xn, yn]) {
                        circle(d = lid_hole_diameter);
                    }
                }
            }
        }
    }
}

module __lid_outline() {
    difference() {
        __box_outline(lid_size);
        __lid_holes();
    }
}

module lid_2d() {
    difference() {
        __lid_outline();
        __lid_bolt_holes_outline(d=bolt_diameter, size=lid_size, box_size=box_size);
    }
}

module lid_3d() {
     color("Aqua") {
        linear_extrude(lid_thickness) {
            lid_2d();
        }
    }
}


lid_2d();
