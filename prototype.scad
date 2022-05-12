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


gear5_pitchRadius = getPitchRadiusFromTeeth(toothThickness, gear5_numberOfTeeth);
gear4_pitchRadius = getPitchRadiusFromTeeth(toothThickness, gear4_numberOfTeeth);
gear3_pitchRadius = getPitchRadiusFromTeeth(toothThickness, gear3_numberOfTeeth);
gear2_pitchRadius = getPitchRadiusFromTeeth(toothThickness, gear2_numberOfTeeth);
gear1_pitchRadius = getPitchRadiusFromTeeth(toothThickness, gear1_numberOfTeeth);


rack_Width = getFullrackWidth(rackHeight,toothHeight);

module gearPoc(numberOfTeeth) {
    color("#FF4500")
        difference() {
            gear(toothThickness,numberOfTeeth,toothHeight,thickness,tolerance);
            translate([0,0,2]) cylinder(thickness+2, d=hole_diameter, $fn=100, center = true);
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
// System
translate([0,-0.3,0]) CentralRack();

translate([getRackLenght(toothThickness, 10.7),0,0]) rotate([0,0,90]) SideRack();
translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPoc(gear5_numberOfTeeth);

mirror([1,0,0]) {
    translate([getRackLenght(toothThickness, 10.7),0,0]) rotate([0,0,90]) SideRack();
    translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
    translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
    translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
    translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
    translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPoc(gear5_numberOfTeeth);
}
/*
Contour();
mirror([1,0,0]) Contour();
*/
include <libp_branch.scad>

circle_diameter=4;
module half_system(circle_diameter) {
    translate([gear1_x,gear1_y,0]) rotate([0,0,angle_1_2]) branch(circle_diameter,gear1_pitchRadius+gear2_pitchRadius,thickness+1);
    translate([gear2_x,gear2_y,0]) rotate([0,0,angle_2_3]) branch(circle_diameter,gear2_pitchRadius+gear3_pitchRadius,thickness+1);
    translate([gear2_x,gear2_y,0]) rotate([0,0,angle_2_4]) branch(circle_diameter,gear2_pitchRadius+gear4_pitchRadius,thickness+1);
    translate([gear4_x,gear4_y,0]) rotate([0,0,angle_4_5]) branch(circle_diameter,gear4_pitchRadius+gear5_pitchRadius,thickness+1);
    distance_1_4= sqrt((gear1_x-gear4_x)^2+(gear1_y-gear4_y)^2);
    angle_1_4=angle_1_2-angle_2_4-176;
    translate([gear1_x,gear1_y,0]) rotate([0,0,angle_1_4]) branch(circle_diameter,distance_1_4,thickness+1);
    distance_1_3= sqrt((gear1_x-gear3_x)^2+(gear1_y-gear3_y)^2);
    translate([gear1_x,gear1_y,0]) branch(circle_diameter,distance_1_3,thickness+1);
    distance_3_border= sqrt((105-gear3_x)^2+(20-gear3_y)^2);
    translate([gear3_x,gear3_y,0]) rotate([0,0,-21])  branch(circle_diameter,distance_3_border,thickness+1);
    translate([10,5,0])  branch(circle_diameter,93,thickness+1);
    distance_1_corner= sqrt((10-gear1_x)^2+(5-gear1_y)^2);
    translate([10,5,0]) rotate([0,0,21])  branch(circle_diameter,distance_1_corner,thickness+1);
    distance_5_corner= sqrt((10-gear5_x)^2+(5-gear5_y)^2);
    translate([10,5,0]) rotate([0,0,77])  branch(circle_diameter,distance_5_corner,thickness+1);
    distance_4_corner= sqrt((10-gear4_x)^2+(5-gear4_y)^2);
    translate([10,5,0]) rotate([0,0,53])  branch(circle_diameter,distance_4_corner,thickness+1);
    distance_5_upcorner= sqrt((10-gear5_x)^2+(gear5_y-gear5_y)^2);
    translate([10,gear5_y,0]) rotate([0,0,0])  branch(circle_diameter,distance_5_upcorner,thickness+1);
    distance_corners= sqrt((10-10)^2+(5-gear5_y)^2);
    translate([10,5,0]) rotate([0,0,90])  branch(circle_diameter,distance_corners,thickness+1);
}

circle_d = 5;

half_system(circle_d);
mirror([1,0,0]) half_system(circle_d);

distance_corners= sqrt((10+8)^2+(5+5)^2);
translate([10,5,0]) rotate([0,0,-180])  branch(circle_d,distance_corners,thickness+1);
translate([10,gear5_y,0]) rotate([0,0,-180])  branch(circle_d,distance_corners,thickness+1);