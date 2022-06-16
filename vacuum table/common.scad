module __fillet(r) {
   offset(r = +r) {
     offset(delta = -r) {
       children();
     }
   }
}

module __chamfer_corners(r) {
    offset(r = +r) {
        offset(delta = -r) {
            children();
        }
    }
}

module __apply_border(size) {
    translate([size, size]) {
        offset(delta = size) {
            children();
        }
    }
}
