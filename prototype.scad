include <libp_gear.scad>
include <lib_spiral.scad>

toothThickness=5;
toothHeight=5;
thickness =3;
tolerance=0.1;
pin_diameter = 5;
hole_diameter = pin_diameter + tolerance;


gear1_numberOfTeeth = 6;
gear2_numberOfTeeth = 8;
gear3_numberOfTeeth = 6;
gear4_numberOfTeeth = 5;
gear5_numberOfTeeth = 10;

centralRack_numberOfTeeth = 14;
sideRack_numberOfTeeth = 4;
rackHeight=7;

angle_1_2 = 42;
angle_2_3 = -angle_1_2;
angle_2_4 = 180-angle_1_2;
angle_4_5 = 138;

gear1_rotation=0;
gear2_rotation=8;
gear3_rotation=42;
gear4_rotation=-13.5;
gear5_rotation=15;

gear1_x=rackHeight+10+getRackLenght(toothThickness, 3)-toothThickness/2;
gear1_y=rackHeight+getPitchRadiusFromTeeth(toothThickness, gear1_numberOfTeeth);

gear2_pos = gearPosition(angle_1_2,toothThickness,gear2_numberOfTeeth, gear1_numberOfTeeth, gear1_x, gear1_y);
gear2_x=gear2_pos[0];
gear2_y=gear2_pos[1];

gear3_pos = gearPosition(angle_2_3,toothThickness,gear3_numberOfTeeth, gear2_numberOfTeeth, gear2_x, gear2_y);
gear3_x=gear3_pos[0];
gear3_y=gear3_pos[1];

gear4_pos = gearPosition(angle_2_4,toothThickness,gear4_numberOfTeeth, gear2_numberOfTeeth, gear2_x, gear2_y);
gear4_x=gear4_pos[0];
gear4_y=gear4_pos[1];

gear5_pos = gearPosition(angle_4_5,toothThickness,gear5_numberOfTeeth, gear4_numberOfTeeth, gear4_x, gear4_y);
gear5_x=gear5_pos[0];
gear5_y=gear5_pos[1];

support_border = 1.5;

spacingGear_Border = tolerance *2;
gear5_fullRadius = getFullRadiusFromTeeth(toothThickness, gear5_numberOfTeeth, toothHeight);
gear4_fullRadius = getFullRadiusFromTeeth(toothThickness, gear4_numberOfTeeth, toothHeight);
gear3_fullRadius = getFullRadiusFromTeeth(toothThickness, gear3_numberOfTeeth, toothHeight);
gear2_fullRadius = getFullRadiusFromTeeth(toothThickness, gear2_numberOfTeeth, toothHeight);
gear1_fullRadius = getFullRadiusFromTeeth(toothThickness, gear1_numberOfTeeth, toothHeight);

rack_Width = getFullrackWidth(rackHeight,toothHeight);

module gearPoc(numberOfTeeth) {
    color("#FF4500")
        difference() {
            gear(toothThickness,numberOfTeeth,toothHeight,thickness,tolerance);
            translate([0,0,2]) cylinder(thickness+2, d=hole_diameter, $fn=100, center = true);
        }
}

module gearPocWithSpring(numberOfTeeth) {
    
    step = 0.2;
    circles = 4;
    arm_len = 3.1;

    b = arm_len / 2 / PI;
    points = [for(theta = [0:step:2 * PI * circles])
        [b * theta * cos(theta * 57.2958), b * theta * sin(theta * 57.2958)]
    ];
    color("#FF4500")
    difference() {
    union() {
        difference() {
            gear(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance);
        translate([0,0,-0.1]) cylinder(thickness+2, r=-1.5+getRootRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight));
         }
        linear_extrude(thickness) polyline(points, 0.8);

        
        translate([0,0,thickness/2]) cylinder(thickness, d=9, $fn=100, center = true);
 }
     translate([0,0,thickness/2]) cylinder(thickness+2, d=hole_diameter+2, $fn=4, center = true); 
    }

}

module SideRack(){
    color("#FF4500") {
        rack(toothThickness, sideRack_numberOfTeeth, toothHeight, rackHeight, thickness, tolerance);
        translate([0,10,0]) {
            cube([4.2,4.2,20]);
            hull() {
                translate([-(20-4.2)/2,0,20-4.2]) cube([20,4.2,4.2]);
                translate([-(10-4.2)/2,4.2,20-4.2]) cube([10,4.2,4.2]);
                }   
            hull() {
                translate([-(20-4.2)/2,0,20-4.2]) cube([20,4.2,4.2]);
                translate([0,0,4.2+3]) cube([4.2,4.2,4.2]);
                }   
            }
        }
}

module CentralRack() {
    module LeftHalfCentralRack() {
        color("#FF4500") {
            rack(toothThickness, centralRack_numberOfTeeth, toothHeight, rackHeight, thickness, tolerance);

            cube([10,5,thickness]);
            translate([10,0,0]){
                cube([5,5,20]);
                hull() {
                    translate([0,0,20-5]) cube([10,5,5]);
                    translate([0,4.2,20-5]) cube([5,4.2,5]);
                }
           }
        }
    }
    union() {
        LeftHalfCentralRack();
        mirror([1,0,0]) LeftHalfCentralRack();
    }
}
module SupportBorder(radius) {
    difference() {
        cylinder(thickness, r=radius+spacingGear_Border+support_border, $fn=100);
        translate([0,0,-1]) cylinder(thickness+2, r=radius+spacingGear_Border, $fn=100);
   }
}
module Contour() {
    
        difference() {
            translate([gear5_x, gear5_y,0]) SupportBorder(gear5_fullRadius);
            translate([gear4_x, gear4_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear4_fullRadius+spacingGear_Border, $fn=100);
            translate([0,0,-1]) cube([rack_Width,200,thickness+2]);
        }
        difference() {
            translate([gear4_x, gear4_y,0]) SupportBorder(gear4_fullRadius);
            translate([gear2_x, gear2_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear2_fullRadius+spacingGear_Border, $fn=100);
            translate([gear5_x, gear5_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear5_fullRadius+spacingGear_Border, $fn=100);
        }
        difference() {
            translate([gear2_x, gear2_y,0]) SupportBorder(gear2_fullRadius);
            translate([gear1_x, gear1_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear1_fullRadius+spacingGear_Border, $fn=100);
            translate([gear4_x, gear4_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear4_fullRadius+spacingGear_Border, $fn=100);
            translate([gear3_x, gear3_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear3_fullRadius+spacingGear_Border, $fn=100);
        }
        difference() {
            translate([gear3_x, gear3_y,0]) SupportBorder(gear3_fullRadius);
            translate([gear2_x, gear2_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear2_fullRadius+spacingGear_Border, $fn=100);    translate([0,0,-1]) 
                cube([getRackLenght(toothThickness, 10.7),rack_Width,thickness+2]);
        }

        difference() {
            translate([gear1_x, gear1_y,0]) SupportBorder(gear1_fullRadius);
            translate([gear2_x, gear2_y,0])translate([0,0,-1]) cylinder(thickness+2, r=gear2_fullRadius+spacingGear_Border, $fn=100);
            translate([0,0,-1]) 
                cube([getRackLenght(toothThickness, 10.7),rack_Width,thickness+2]);
        }
        difference() {
            translate([0,0,0]) 
                cube([getRackLenght(toothThickness, 10.7),rack_Width+support_border,thickness]);
            translate([0,0,-1]) 
                cube([getRackLenght(toothThickness, 10.7),rack_Width,thickness+2]);
            translate([gear1_x, gear1_y,0])
                translate([0,0,-1]) 
                    cylinder(thickness+2, r=gear1_fullRadius+spacingGear_Border, $fn=100);
            translate([gear3_x, gear3_y,0])
                translate([0,0,-1])
                    cylinder(thickness+2, r=gear3_fullRadius+spacingGear_Border, $fn=100);
            translate([0,0,-1]) 
                cube([rack_Width,getRackLenght(toothThickness, 9),thickness+2]);
            
        }

        difference() {
            translate([0,0,0]) 
                cube([rack_Width+support_border,getRackLenght(toothThickness, 8.6),thickness]);
            translate([0,0,-1]) 
                cube([rack_Width,getRackLenght(toothThickness, 8.6),thickness+2]);
            translate([0,0,-1]) 
                cube([getRackLenght(toothThickness, 10.7),rack_Width,thickness+2]);
            translate([gear5_x, gear5_y,0])
                translate([0,0,-1])
                    cylinder(thickness+2, r=gear5_fullRadius+spacingGear_Border, $fn=100);
        }
   
}
/*
module support_with_hole() {
  difference() {
      support();
     translate([10,20,-2]) cube([5,20,10]);
  }
}
*/// 
// System
translate([0,-0.3,0]) CentralRack();

translate([getRackLenght(toothThickness, 10.7),0,0]) rotate([0,0,90]) SideRack();
translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPocWithSpring(gear5_numberOfTeeth);

mirror([1,0,0]) {
    translate([getRackLenght(toothThickness, 10.7),0,0]) rotate([0,0,90]) SideRack();
    translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
    translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
    translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
    translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
    translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPocWithSpring(gear5_numberOfTeeth);
}

Contour();
mirror([1,0,0]) Contour();