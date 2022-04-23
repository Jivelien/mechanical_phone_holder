module foot() {
    rotate([70,0,0]) {
    translate([10.1,0,-1]) cube([4.8,20,5]);
    translate([0,0,-2.1]) cube([14.8,20,2]);
    }
}
module foot_supp() {
    rotate([70,0,0]) {
    translate([10.1,0,-1]) cube([4.8,20,5]);
    }
}

translate([0,0,70]) {
    foot();
    mirror([1,0,0]) foot();
}

hull() {
    #translate([0,0,70]) rotate([70,0,0])translate([10.1,0,-2]) cube([4.8,20,1]);
    translate([-25/2,20,0]) cube([5,25,1]);
}

mirror([1,0,0]) hull() {
    translate([0,0,70]) rotate([70,0,0])translate([10.1,0,-2]) cube([4.8,20,1]);
    translate([-25/2,20,0]) cube([5,25,1]);
}
difference() {
translate([0,0,-5]) cylinder(5, d=104, $fn=6);
translate([0,-13.5,-6]) cylinder(7, d=104-27, $fn=6);
}