/* OpenSCAD library for creating a LumenPNP staging plate.

To generate the "standard" staging plate, just run this program with OpenSCAD.

You can also generate custom staging plates, for example, if you wanted one without the camera hole:

    use <staging_plate.scad>
    
    staging_plate(camera_hole = false);

The staging_plate() module has a bunch of arguments for configuring a specific staging plate.

Dimensional arguments:
* width, height, thickness: the overall dimensions.
* fillet_radius: the amount to fillet the outside edges of the plate.
* center: if true, the plate will be centered on the coordinate origin. If false, the plate's bottom-left corner will be placed on the coordinate origin.

Accessory grid arguments:
* grid_holes: if true, a grid of accessory holes will be included.
* grid_spacing: the spacing between each of the accessory holes.
* grid_offset: the offset from the edge of the staging plate where the accessory hole grid begins.
* grid_hole_diameter: the diameter of each accessory hole. This should be set according to which machine screws you want to use for mounting accessories.

Mounting hole arguments:
* mounting_holes: if true, holes for mounting the plate to the machine's frame will be included.
* mounting_hole_offset: the offset from the edge of the staging plate where the mounting holes will be placed. This should be set so that the mounting holes match with the machine's aluminum extrusion slots.
* mounting_hole_diameter: the diameter of the mounting holes. This should be set according to the mounting hardware used to mount the plate to the machine.

Camera hole arguments:
* camera_hole: if true, a hole for the bottom (upwards-facing) camera will be included.
* camera_hole: the diameter of the camera's hole. This should be set according to the mounting mechanism for the camera.
    
In addition, you can use the staging_plate_grid_holes(), staging_plate_mounting_holes(), and staging_plate_camera_hole() modules directly to incorporate aspects of the staging plate into other designs- such as using the grid holes to cut matching holes in accessories.

License: CC BY-SA 2.0 (https://creativecommons.org/licenses/by-sa/2.0/)
Author: Alethea Flowers
*/



module staging_plate(width = 600, height = 120, thickness = 3, fillet_radius = 6, center = true, grid_holes = true, grid_spacing=[30, 15], grid_offset = [15, 15], grid_hole_diameter = 3.4, mounting_holes = true, mounting_hole_offset = [10, 10], mounting_hole_diameter=5.5, camera_hole=true, camera_hole_diameter = 45) {
    offset = center ? [-width / 2, -height / 2] : [0, 0];
    color("black") {
        translate(offset) {
            linear_extrude(thickness) {
                difference() {
                    __staging_plate_round_those_corners_bb(r=fillet_radius) {
                        square([width, height]);
                    }
                    if(mounting_holes) staging_plate_mounting_holes(width, height, mounting_hole_offset, mounting_hole_diameter);
                    if(grid_holes) staging_plate_grid_holes(width, height, grid_spacing, grid_offset, grid_hole_diameter);
                    if(camera_hole) staging_plate_camera_hole(width, height, camera_hole_diameter);
                }
            }
        }
    }
}

module staging_plate_mounting_holes(plate_width, plate_height, offset, diameter) {
    translate(offset) {
        circle(d=diameter);
    }
    translate([plate_width - offset[0], offset[1]]) {
        circle(d=diameter);
    }
    translate([plate_width - offset[0], plate_height - offset[1]]) {
        circle(d=diameter);
    }
    translate([offset[0], plate_height - offset[1]]) {
        circle(d=diameter);
    }
}

module staging_plate_grid_holes(plate_width, plate_height, spacing, offset, diameter) {
    grid_count_x = ceil((plate_width - offset[0] * 2) / spacing[0]);
    grid_count_y = ceil((plate_height - offset[1] * 2) / spacing[1]);
    grid_cutoff_x = plate_width - offset[0];
    grid_cutoff_y = plate_height - offset[1];

    translate(offset) {
        for(yn = [0:grid_count_y]) {
            stagger_x_offset = yn % 2 == 0 ? 0 : spacing[0] / 2;
            stagger_count_offset = yn % 2 == 0 ? 0 : -1;
            for(xn = [0:grid_count_x + stagger_count_offset]) {
                _x = spacing[0] * xn + stagger_x_offset;
                _y = spacing[1] * yn;
                if(_x < grid_cutoff_x && _y < grid_cutoff_y) {
                    translate([_x, spacing[1] * yn]) {
                        circle(d = diameter);
                    }
                }
            }
        }
    }
};


module staging_plate_camera_hole(plate_width, plate_height, diameter) {
    translate([plate_width / 2, plate_height / 2]) {
        circle(d=diameter);
    }
}

module __staging_plate_round_those_corners_bb(r) {
   offset(r = +r) {
     offset(delta = -r) {
       children();
     }
   }
}


staging_plate();

