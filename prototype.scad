include <libp_gear.scad>
include <lib_spiral.scad>
include <libp_branch.scad>
include <flat_springV1_3.scad>

toothThickness=5;
toothHeight=5;
thickness =3;
tolerance=0.1;
pin_diameter = 5;
donut_thickness = 0;
hole_diameter = pin_diameter + tolerance;

gear1_numberOfTeeth = 6;
gear2_numberOfTeeth = 8;
gear3_numberOfTeeth = 6;
gear4_numberOfTeeth = 5;
gear5_numberOfTeeth = 10;

centralRack_numberOfTeeth = 14;
sideRack_numberOfTeeth = 4;
sideRackHeight=7;
centralRackHeight=12;
sideRack_translate=11.2;

top_thickness=2;
branch_diameter=5;


pin_height= donut_thickness*2 + top_thickness*2 + tolerance *2 + thickness;

angle_1_2 = 42;
angle_2_3 = -angle_1_2;
angle_2_4 = 180-angle_1_2;
angle_4_5 = 138;

gear1_rotation=0;
gear2_rotation=8;
gear3_rotation=42;
gear4_rotation=-13.5;
gear5_rotation=15;

gear1_x=centralRackHeight+10+getRackLenght(toothThickness, 3)-toothThickness/2;
gear1_y=sideRackHeight+getPitchRadiusFromTeeth(toothThickness, gear1_numberOfTeeth);

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


module gearPoc(numberOfTeeth) {
    color("#FF4500")
        difference() {
            gear(toothThickness,numberOfTeeth,toothHeight,thickness,tolerance);
            translate([0,0,2]) cylinder(thickness+2, d=hole_diameter, $fn=100, center = true);
        }
}

module SideRack(){
    a=getSolidrackWidth(sideRackHeight, toothHeight);
    color("#FF4500") {
        rack(toothThickness, sideRack_numberOfTeeth, toothHeight, sideRackHeight, thickness, tolerance);
        translate([0,10,0]) {
            cube([a,a,20]);
            hull() {
                translate([0/2,0,20-a]) cube(a);
                #translate([-(20-a)/2,0,10-a]) cube([20,a,a+3]);
                }   
            }
        }
}

module CentralRack() {
    module LeftHalfCentralRack() {
        difference(){
            
                rack(toothThickness, centralRack_numberOfTeeth, toothHeight, centralRackHeight, thickness, tolerance);
            translate([-1,7.5,-1]) cube([7,120,5]);
            }
            cube([10,5,thickness]);
            translate([10,0,0]){
                cube([5,getSolidrackWidth(sideRackHeight,toothHeight),20]);
                hull() {
                    translate([0,0,20]) cube([10,getSolidrackWidth(sideRackHeight,toothHeight),5]);
                    translate([0,4.2,20]) cube([5,4.2,5]);
                }
           }
    }
    color("#FF4500") {
        union() {
            LeftHalfCentralRack();
            mirror([1,0,0]) LeftHalfCentralRack();
            
            translate([-4/2,10,1.5]) spring_maker(radius = 3, thickness = 1, depth = 3, width = 4, spring_count = 8, end_len = 0);
            translate([-4/2,60.5,]) cube([4,1,5.1]);
        }
    }
}

/*
Contour();
mirror([1,0,0]) Contour();
*/
module branch_set(circle_diameter,thickness=thickness,bottom=true) {
    translate([gear1_x,gear1_y,0]) 
        rotate([0,0,angle_1_2]) 
            branch(circle_diameter,gear1_pitchRadius+gear2_pitchRadius,thickness);
    
    translate([gear2_x,gear2_y,0]) 
        rotate([0,0,angle_2_3]) 
            branch(circle_diameter,  gear2_pitchRadius+gear3_pitchRadius,thickness);
    
    translate([gear2_x,gear2_y,0]) 
        rotate([0,0,angle_2_4])
            branch(circle_diameter,gear2_pitchRadius+gear4_pitchRadius,thickness);
    
    translate([gear4_x,gear4_y,0]) 
        rotate([0,0,angle_4_5])
            branch(circle_diameter,gear4_pitchRadius+gear5_pitchRadius,thickness);
    
    distance_1_4= sqrt((gear1_x-gear4_x)^2+(gear1_y-gear4_y)^2);
    angle_1_4=angle_1_2-angle_2_4-176;
    translate([gear1_x,gear1_y,0]) 
        rotate([0,0,angle_1_4]) 
            branch(circle_diameter,distance_1_4,thickness);
    
    distance_1_3= sqrt((gear1_x-gear3_x)^2+(gear1_y-gear3_y)^2);
    translate([gear1_x,gear1_y,0]) 
        branch(circle_diameter,distance_1_3,thickness);
    
    branch_3_out_x = getRackLenght(toothThickness, sideRack_translate) ;
    branch_3_out_y = sideRackHeight/2 ;
    distance_3_border= sqrt((branch_3_out_x-gear3_x)^2+(branch_3_out_y-gear3_y)^2);
    translate([gear3_x,gear3_y,0]) 
        rotate([0,0,-22])  
            branch(circle_diameter,distance_3_border,thickness);
    
    bottom_branch_x=centralRackHeight+toothHeight/2;
    bottom_branch_y=5;
    bottom_branch_lenght=branch_3_out_x-bottom_branch_x+1;
    translate([bottom_branch_x,bottom_branch_y,0])
        branch(circle_diameter,bottom_branch_lenght,thickness);
    if (bottom) {
        translate([bottom_branch_x+bottom_branch_lenght,2,0]) cylinder(thickness, r=8);
        difference() {
        translate([bottom_branch_x,bottom_branch_y-6,0])
            branch(circle_diameter,bottom_branch_lenght,thickness+5.2);
       
        translate([bottom_branch_x+bottom_branch_lenght,2,0]) difference() {
            cylinder(thickness+5.4, r=8.1);
            translate([-16,-18.2,0]) cube(16);
            }
            
        translate([bottom_branch_x+bottom_branch_lenght,2,thickness+3+donut_thickness+tolerance]) cylinder(thickness+5.4, r=8.1);
        a=200;
        translate([-a/2,-tolerance,-0.5]) cube([a+2,getSolidrackWidth(sideRackHeight,toothHeight)+tolerance*2,thickness+6]);
       
        translate([0,-10,0]) cube(15.2); 
            
       }
    }
    translate([bottom_branch_x+bottom_branch_lenght,2,0]) cylinder(thickness, r=8);
    
    distance_1_corner= sqrt((bottom_branch_x-gear1_x)^2+(bottom_branch_y-gear1_y)^2);
    translate([bottom_branch_x,bottom_branch_y,0])
        rotate([0,0,21])
            branch(circle_diameter,distance_1_corner,thickness);
    
    distance_5_corner= sqrt((bottom_branch_x-gear5_x)^2+(bottom_branch_y-gear5_y)^2);
    translate([bottom_branch_x,bottom_branch_y,0])
        rotate([0,0,76.5])
            branch(circle_diameter,distance_5_corner,thickness);
    
    distance_4_corner= sqrt((bottom_branch_x-gear4_x)^2+(bottom_branch_y-gear4_y)^2);
    translate([bottom_branch_x,bottom_branch_y,0])
        rotate([0,0,52])
            branch(circle_diameter,distance_4_corner,thickness);
    
    distance_5_upcorner= sqrt((bottom_branch_x-gear5_x)^2+(gear5_y-gear5_y)^2);
    translate([bottom_branch_x,gear5_y,0])
        rotate([0,0,0])
            branch(circle_diameter,distance_5_upcorner,thickness);
    
    distance_corners= sqrt((bottom_branch_x-bottom_branch_x)^2+(bottom_branch_y-gear5_y)^2);
    translate([bottom_branch_x,bottom_branch_y,0])
        rotate([0,0,90])
            branch(circle_diameter,distance_corners,thickness);
}
        
module half_system(circle_diameter,thickness=thickness) {
    difference() {
        union() {
            translate([gear1_x,gear1_y,-donut_thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
            translate([gear2_x,gear2_y,-donut_thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
            translate([gear3_x,gear3_y,-donut_thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
            translate([gear4_x,gear4_y,-donut_thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
            translate([gear5_x,gear5_y,-donut_thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
            branch_set(circle_diameter,thickness=thickness, bottom=false);
                }
                    
    translate([gear1_x,gear1_y,-donut_thickness-1]) cylinder(thickness+2,r=pin_diameter/2);
    translate([gear2_x,gear2_y,-donut_thickness-1]) cylinder(thickness+2,r=pin_diameter/2);
    translate([gear3_x,gear3_y,-donut_thickness-1]) cylinder(thickness+2,r=pin_diameter/2);
    translate([gear4_x,gear4_y,-donut_thickness-1]) cylinder(thickness+2,r=pin_diameter/2);
    translate([gear5_x,gear5_y,-donut_thickness-1]) cylinder(thickness+2,r=pin_diameter/2);
    }
}

module donut(radius, hole_radius, thickness) {
    linear_extrude(thickness) difference() {
        circle(r=radius);
        circle(r=hole_radius);
    }
}

module top(circle_diameter,thickness=thickness) {
    difference() {
        union() {
            half_system(circle_diameter, thickness);
            mirror([1,0,0]) half_system(circle_diameter, thickness);


            u_x=centralRackHeight+toothHeight/2;
            u_y=toothHeight;
            distance_corners= sqrt((u_x+u_x)^2+(u_y+u_y)^2);

            translate([distance_corners/2,u_y,0])
                rotate([0,0,-180])
                    branch(circle_diameter,distance_corners,thickness);

            translate([distance_corners/2,gear5_y,0])
                rotate([0,0,-180])
                    branch(circle_diameter,distance_corners,thickness);
        }
    a=200;
    translate([-a/2,-tolerance,-0.5]) cube([a,getSolidrackWidth(sideRackHeight,toothHeight)+tolerance*2,thickness+1]);
    }
}


module bottom(circle_diameter,thickness=thickness) {
    module half(circle_diameter,thickness=thickness) {
        translate([gear1_x,gear1_y,thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
        translate([gear2_x,gear2_y,thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
        translate([gear3_x,gear3_y,thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
        translate([gear4_x,gear4_y,thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);
        translate([gear5_x,gear5_y,thickness]) donut(branch_diameter,pin_diameter/2,donut_thickness);

    
        translate([gear1_x,gear1_y]) cylinder(pin_height,d=pin_diameter);
        translate([gear2_x,gear2_y]) cylinder(pin_height,d=pin_diameter);
        translate([gear3_x,gear3_y]) cylinder(pin_height,d=pin_diameter);
        translate([gear4_x,gear4_y]) cylinder(pin_height,d=pin_diameter);
        translate([gear5_x,gear5_y]) cylinder(pin_height,d=pin_diameter);
            
        difference() {
            branch_set(circle_diameter, thickness);
            translate([15.5,10,-5]) cube([2.5,15,20]);
        }
        translate([108,2,])
        difference() {
            cylinder(thickness+tolerance*2+3+donut_thickness, r=8);
            translate([-16,-8,0]) cube([16,16,thickness+tolerance*2+3+donut_thickness+1]);
        }
            translate([14.5,4,0]) cube([1,40,5]);
            
    }
union() {
        half(circle_diameter, thickness);
        mirror([1,0,0]) half(circle_diameter, thickness);


        u_x=centralRackHeight+toothHeight/2;
        u_y=toothHeight;
        distance_corners= sqrt((u_x+u_x)^2+(u_y+u_y)^2);

        translate([distance_corners/2,u_y,0])
            rotate([0,0,-180])
                branch(circle_diameter,distance_corners,thickness);
            translate([distance_corners/2,u_y-6,0])
                rotate([0,0,-180])
                    branch(circle_diameter,distance_corners,thickness);

        translate([distance_corners/2,gear5_y,0])
            rotate([0,0,-180])
                branch(circle_diameter,distance_corners,thickness);
    
    }
}

module system() {
    translate([0,-0.3,0]) CentralRack();

    translate([getRackLenght(toothThickness, sideRack_translate),0,0]) rotate([0,0,90]) SideRack();
    translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
    translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
    translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
    translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
    translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPoc(gear5_numberOfTeeth);

    mirror([1,0,0]) {
        translate([getRackLenght(toothThickness, sideRack_translate),0,0]) rotate([0,0,90]) SideRack();
        translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(gear1_numberOfTeeth);
        translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(gear2_numberOfTeeth);
        translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(gear3_numberOfTeeth);
        translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(gear4_numberOfTeeth);
        translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPoc(gear5_numberOfTeeth);
    }
}

module main_part() {
    system();
    difference() {
        translate([0,0,thickness+donut_thickness+tolerance]) {
        top(branch_diameter, top_thickness);
    }
            
        translate([-4/2-0.05,60.1,]) cube([4.1,1.1,10]);
    }

    translate([0,0,-donut_thickness-tolerance-top_thickness]) {
            bottom(branch_diameter, top_thickness);
    }
}
translate([0,0,60]) rotate([70,0,0]) main_part();

translate([0,0,60]) rotate([70,0,0]) translate([15.55,10.05,-4]) cube([2.4,14.9,6.5]);
translate([0,0,60]) rotate([70,0,0]) translate([-15.45-2.5,10.05,-4]) cube([2.4,14.9,6.5]);
translate([0,0,60]) rotate([70,0,0]) translate([-(15.55+15.45+2.5+2.5)/2,10.05,-4.2]) cube([15.55+15.45+2.5+2.5,14.9,2]);