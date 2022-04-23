ratio = PI*1.018/2;

toothHeight = 5;
thickness = 3;
tolerance = 0.1;

rotation_param = 0;
pitch= 4.92363;

include <lib_rack_and_gear.scad>

module poc_gear(i) {
    difference()
        {
            gear(i*ratio, i, toothHeight, thickness);
            translate([0,0,-1]) cylinder(thickness+2,d=5.2, $fn=100);
        }
    }

module system() {
      translate([7,7,1.1]) {
        translate([0,9.5,0]) {  
            translate([60,0,0]) rotate([0,0,17]) poc_gear(6);
            translate([30,0,0]) rotate([0,0,4]) poc_gear(6);
            translate([45,17,0]) rotate([0,0,60]) poc_gear(8);
            translate([25,23,0]) rotate([0,0,-32.5]) poc_gear(5);
            translate([16,45.5,0]) rotate([0,0,-14]) poc_gear(10);
            translate([0,-21.2,0]) {
            union() {
                rack(ratio, 1, toothHeight, thickness, 15,7);
                translate([-3,0,0]) {
                    cube([10,5,thickness]);
                    translate([5,0,0]) {
                           cube([5,5,20]);
                        hull() {
                           translate([0,0,17]) cube([15,5,3]);
                           translate([0,5,17]) cube([10,5,3]);
                        }
                    }
                    
                }
            }
            }
        }
        translate([58+40,0,0]) rotate([0,0,90]) {
            difference() {
                rack(ratio, 1, toothHeight, thickness, 4,7);
                translate([-8,-5,-1]) cube([8,pitch/2+5,thickness+2]);
                translate([-8,37.61,-1]) cube([8,pitch/2+5,thickness+2]);
              }
            translate([-7,pitch*2,0]) {
                cube([4.2,5,thickness+20]);
                hull() {
                    translate([-7.5,0,20]) cube([20,5,3]);
                    translate([-2.5,5,20]) cube([10,5,3]);
                }
            }
          }
    }  
}
system();
mirror([1,0,0]) {
system();
}
module support() {
union() {
    translate([7,7,0]) {
        translate([0,9.5,0]) {  
            translate([60,0,0]) rotate([0,0,17]) cylinder(5, d=4.8, $fn=100);
            translate([30,0,0]) rotate([0,0,7]) cylinder(5, d=4.8, $fn=100);
            translate([45,17,0]) rotate([0,0,60]) cylinder(5, d=4.8, $fn=100);
            translate([25,23,0]) rotate([0,0,-34]) cylinder(5, d=4.8, $fn=100);
            translate([16,45.5,0]) rotate([0,0,-13]) cylinder(5, d=4.8, $fn=100);
        }
    }

    translate([20,-2,0]) cube([80,2,5]);

    hull() {
    translate([-2,50,0]) cube([2,50,1]);
    translate([50,-2,0]) cube([50,2,1]);
    }
}
}
%union() {
support();
mirror([1,0,0]) support();
}


