use <staging_plate.scad>

/* Change to your board's dimensions: width, height, thickness */
pcb_size = [150, 100, 1.6];
pcb_holder(pcb_size = pcb_size, $fn = 20);


module pcb_holder(
        pcb_size,
        staging_height = 10,
        lip_height = 2,
        lip_width = 3,
        staging_plate_spacing = [30, 15],
        screw_diameter = 3.2,
        screw_head_diameter = 6.2,
        screw_head_height = 3) {

    staging_height = staging_height - pcb_size[2];
    frame_size = [pcb_size.x + lip_width * 2, pcb_size.y + lip_width * 2, staging_height + lip_height];
    grid_offset = [lip_width + screw_head_diameter / 2 + 1, lip_width + screw_head_diameter / 2 + 1];
    staging_plate_size = frame_size - grid_offset;
    inset_amount = grid_offset[0] + screw_head_diameter / 2 + 1;

    difference() {
        __frame(frame_size = frame_size, inset_amount=inset_amount);
        __pcb(
            pcb_size = pcb_size, frame_size = frame_size, staging_height = staging_height, lip_height = lip_height);
        __pcb_edges(
            frame_size = frame_size, staging_height = staging_height, lip_height = lip_height, lip_width = lip_width);
        __mounting_holes(
            staging_plate_size = staging_plate_size,
            staging_plate_spacing = staging_plate_spacing,
            grid_offset = grid_offset,
            staging_height = staging_height,
            screw_diameter = screw_diameter,
            screw_head_diameter = screw_head_diameter,
            screw_head_height = screw_head_height);
        __labels(frame_size=frame_size);
    }
}

module __chamfer_corners(r) {
    offset(delta = +r, chamfer=true) {
        offset(delta = -r) {
            children();
        }
    }
}

function __lowest_cell_for(pos) = [ floor(pos[0] / 15), floor(pos[1] / 15) ];
function __cell_pos(cell) = [cell[0] * 15, cell[1] * 15];

module __bottom_left_sq() {
     square(45);
}

module __bottom_right_sq(frame_size) {
    _pos = [frame_size.x - 45, 45];
            _lower_pos = __cell_pos(__lowest_cell_for(_pos));
            _higher_pos = [frame_size.x, 0];
    translate([_lower_pos[0], 0]) square([frame_size.x - _lower_pos[0], _lower_pos[1]]);
}

module __top_right_sq(frame_size) {
    _pos = [frame_size.x - 45, frame_size.y - 45];
    _lower_pos = __cell_pos(__lowest_cell_for(_pos));
    _higher_pos = [frame_size.x, frame_size.y];
    translate(_lower_pos) square(_higher_pos - _lower_pos);
}

module __top_left_sq(frame_size) {
    _pos = [45, frame_size.y - 45];
    _lower_pos = __cell_pos(__lowest_cell_for(_pos));
    _higher_pos = [frame_size.x, frame_size.y];
    translate([0, _lower_pos[1]]) square([_lower_pos[0], frame_size.y - _lower_pos[1]]);
}

module __all_sqs(frame_size) {
    union() {
        __bottom_left_sq();
        __bottom_right_sq(frame_size);
        __top_right_sq(frame_size);
        __top_left_sq(frame_size);
    }
}

module __center_cutout(frame_size, inset_amount) {
    inset_size = [floor(frame_size.x/15) * 15 - inset_amount * 2 - 1, floor(frame_size.y/15) * 15 - inset_amount * 2 - 1];
    translate([inset_amount, inset_amount]) {
        __chamfer_corners(3) {
            square([inset_size.x, inset_size.y]);
        }
    }
}

module __frame(frame_size, inset_amount) {
    linear_extrude(frame_size.z) {
        __chamfer_corners(3) {
            intersection() {
                difference() {
                    square([frame_size.x, frame_size.y]);
                    __center_cutout(frame_size = frame_size, inset_amount = inset_amount);
                }
                __all_sqs(frame_size);
            }
        }
    }
}

module __pcb(pcb_size, frame_size, staging_height, lip_height) {
    pcb_position = [frame_size.x / 2 - pcb_size.x / 2, frame_size.y / 2 - pcb_size.y / 2, staging_height];
    translate(pcb_position) {
        linear_extrude(lip_height + 0.02) {
            square([pcb_size.x, pcb_size.y]);
        }
    }
}

module __pcb_edges(frame_size, staging_height, lip_height, lip_width) {
    translate([0, 0, staging_height]) {
        linear_extrude(lip_height + 0.02) {
            translate([0, 0]) {
                rotate(45) {
                    square([lip_width * 10, lip_width * 4], center=true);
                }
            }
            translate([frame_size.x, 0]) {
                rotate(135) {
                    square([lip_width * 10, lip_width * 4], center=true);
                }
            }
            translate([frame_size.x, frame_size.y]) {
                rotate(45) {
                    square([lip_width * 10, lip_width * 4], center=true);
                }
            }
            translate([0, frame_size.y]) {
                rotate(135) {
                    square([lip_width * 10, lip_width * 4], center=true);
                }
            }
        }
    }
}

module __label(content, align, face=0) {
    translate([3, 0.5, 2]) rotate([90, 0, face]) linear_extrude(2) text(content, size=5, font="Liberation Mono:style=Bold", halign=align);
}

module __labels(frame_size) {
    __label("0,0", align="left");
    translate([frame_size.x - 6, 0]) {
        __label(str(pcb_size[0], ",0"), align="right");
    }
    translate([frame_size.x - 6, frame_size.y - 1]) {
        __label(str(pcb_size[0], ",", pcb_size[1]), align="left", face=180);
    }
    translate([0, frame_size.y - 1]) {
        __label(str("0,", pcb_size[1]), align="right", face=180);
    }
}

module __mounting_holes(
        staging_plate_size,
        staging_plate_spacing,
        grid_offset,
        staging_height,
        screw_diameter,
        screw_head_diameter,
        screw_head_height) {

    translate([0, 0, -0.02]) {
        linear_extrude(20) {
            staging_plate_grid_holes(plate_width=staging_plate_size.x, plate_height=staging_plate_size.y, spacing=staging_plate_spacing, offset=grid_offset, diameter=screw_diameter);
        }
    }

    translate([0, 0, staging_height - screw_head_height]) {
        linear_extrude(10) {
            staging_plate_grid_holes(plate_width=staging_plate_size.x, plate_height=staging_plate_size.y, spacing=staging_plate_spacing, offset=grid_offset, diameter=screw_head_diameter);
        }
    }
}
