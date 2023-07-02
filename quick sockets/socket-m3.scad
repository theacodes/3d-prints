$fn = 50;
label="10";
nut_short_diameter=10.02;
nut_diameter=2 * (nut_short_diameter / sqrt(3));

outer_diameter=nut_diameter + 4;
height = 25;
fin_width = outer_diameter + 12;
fin_thickness = 3;
fin_offset = 3;



difference() {
    union() {
        linear_extrude(height) {
            circle(d=outer_diameter);
        }
        rotate([90, 0, 0]){
            translate([0, fin_offset, -fin_thickness / 2]){
                linear_extrude(fin_thickness) {
                    difference() {
                        circle(d=fin_width);
                        translate([0, -fin_width / 2 - fin_offset, 0]){
                            square([fin_width, fin_width], true);
                        }
                    }
                }
            }
        }
    }
    translate([0, 0, 3]) {
        linear_extrude(height * 100) {
            circle(d=nut_diameter, $fn=6);
        }
    }
    translate([0, 0, -1]){
        linear_extrude(2) {
            rotate([0, 180, 0]){
            text(label, size=outer_diameter * 0.4, font="Nunito Extra Bold", halign="center", valign="center");
            }
        }
    }
}