include <libp_gear.scad>
include <lib_spiral.scad>

toothThickness=5;
toothHeight=5;
thickness =3;
tolerance=0.1;
pin_diameter = 5;
hole_diameter = pin_diameter + tolerance*2;

module gearPoc(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance=0) {
    difference() {
        gear(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance);
        translate([0,0,2]) cylinder(thickness+2, d=hole_diameter, $fn=100, center = true);
    }
}

module gearPocWithSpring(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance=0) {
    
    step = 0.2;
    circles = 4.5;
    arm_len = 2.8;

    b = arm_len / 2 / PI;
    points = [for(theta = [0:step:2 * PI * circles])
        [b * theta * cos(theta * 57.2958), b * theta * sin(theta * 57.2958)]
    ];
    difference() {
    union() {
        difference() {
            gear(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance);
        translate([0,0,-0.1]) cylinder(thickness+2, r=-2+getRootRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight));
         }
        linear_extrude(thickness) polyline(points, 0.8);
        //rotate([0,0,130]) linear_extrude(thickness) polyline(points, 0.8);
        //rotate([0,0,260]) linear_extrude(thickness) polyline(points, 0.8);
        rotate([0,0,180]) linear_extrude(thickness) polyline(points, 0.8);
        
        translate([0,0,thickness/2]) cylinder(thickness, d=9, $fn=100, center = true);
 }
     translate([0,0,thickness/2]) cylinder(thickness+2, d=hole_diameter+2, $fn=4, center = true); 
    }

}






rackHeight=7;


gear1_numberOfTeeth = 6;
gear2_numberOfTeeth = 8;
gear3_numberOfTeeth = 6;
gear4_numberOfTeeth = 5;
gear5_numberOfTeeth = 10;

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


module system() {
    translate([getRackLenght(toothThickness, 10)+rackHeight,0,0]) rotate([0,0,90])
    color("#FF4500") {
        rack(toothThickness, 4, toothHeight, rackHeight, thickness, tolerance);
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
    
    translate([0,-0.3,0]) 
    color("#FF4500") {
        difference(){
            rack(toothThickness, 12, toothHeight, rackHeight, thickness, tolerance);
            translate([4.2,0,-1]) cube([5,5,5]);
        }
        cube([10,4.2,thickness]);
        translate([10,0,0]){
            cube([4.2,4.2,20]);
            hull() {
                translate([0,0,20-4.2]) cube([10,4.2,4.2]);
                translate([0,4.2,20-4.2]) cube([5,4.2,4.2]);
            }
       }
    }
    color("#FF4500") translate([gear1_x,gear1_y,0]) rotate([0,0,gear1_rotation]) gearPoc(toothThickness,gear1_numberOfTeeth,toothHeight,thickness,tolerance);

    color("#FF4500") translate([gear2_x,gear2_y,0]) rotate([0,0,gear2_rotation]) gearPoc(toothThickness,gear2_numberOfTeeth,toothHeight,thickness,tolerance);

    color("#FF4500") translate([gear3_x,gear3_y,0]) rotate([0,0,gear3_rotation]) gearPoc(toothThickness,gear3_numberOfTeeth,toothHeight,thickness,tolerance);

    color("#FF4500") translate([gear4_x,gear4_y,0]) rotate([0,0,gear4_rotation]) gearPoc(toothThickness,gear4_numberOfTeeth,toothHeight,thickness,tolerance);

    color("#FF4500") translate([gear5_x,gear5_y,0]) rotate([0,0,gear5_rotation]) gearPocWithSpring(toothThickness,gear5_numberOfTeeth,toothHeight,thickness,tolerance);
    }

translate([0,0,2]) {
    system() ;
mirror([1,0,0]) system() ;
}

module support() {
    translate([gear1_x, gear1_y]) cylinder(thickness+4,d=pin_diameter, $fn=100);
    translate([gear1_x, gear1_y]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    translate([gear2_x, gear2_y]) cylinder(thickness+4,d=pin_diameter, $fn=100);
    translate([gear2_x, gear2_y]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    translate([gear3_x, gear3_y]) cylinder(thickness+4,d=pin_diameter, $fn=100);
    translate([gear3_x, gear3_y]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    translate([gear4_x, gear4_y]) cylinder(thickness+4,d=pin_diameter, $fn=100);
    translate([gear4_x, gear4_y]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    translate([gear5_x, gear5_y]) rotate([0,0,15]) cylinder(thickness+4,d=pin_diameter+2, $fn=4);
    translate([gear5_x, gear5_y]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    hull() {
        cube([gear3_x+pin_diameter,gear3_y+1,1]);
        cube([gear5_x+pin_diameter,gear5_y+pin_diameter,1]);
    }
    
    translate([0,-0.1,0]) cube([gear3_x+pin_diameter,9.3,1.9]);
    translate([15,-1.1,0]) cube([gear3_x+pin_diameter-15,1,3+1+1]);
    translate([9.5,5,0]) cube([1,40,3+1+1]);
    
    cube([10,gear5_y+pin_diameter,1.9]);
}

module support_top() {
    difference() {
        union() {
        translate([0,4.9,0])  hull() {
            cube([gear3_x+pin_diameter,gear3_y+pin_diameter-4.9,1]);
            cube([gear5_x+pin_diameter,gear5_y+pin_diameter-4.9,1]);
        }
           translate([gear1_x, gear1_y,-1]) cylinder(1.9,d=4+pin_diameter, $fn=6);
        translate([gear2_x, gear2_y,-1]) cylinder(1.9,d=4+pin_diameter, $fn=6);
        translate([gear3_x, gear3_y,-1]) cylinder(1.9,d=4+pin_diameter, $fn=6);
        translate([gear4_x, gear4_y,-1]) cylinder(1.9,d=4+pin_diameter, $fn=6);
        translate([gear5_x, gear5_y,-1]) cylinder(1.9,d=4+pin_diameter, $fn=6);

    }
    translate([gear1_x, gear1_y,-3]) cylinder(thickness+4,d=pin_diameter+tolerance*1.5, $fn=100);
    translate([gear2_x, gear2_y,-3]) cylinder(thickness+4,d=pin_diameter+tolerance*1.5, $fn=100);
    translate([gear3_x, gear3_y,-3]) cylinder(thickness+4,d=pin_diameter+tolerance*1.5, $fn=100);
    translate([gear4_x, gear4_y,-3]) cylinder(thickness+4,d=pin_diameter+tolerance*1.5, $fn=100);
    translate([gear5_x, gear5_y,-3]) rotate([0,0,15]) cylinder(thickness+4,d=pin_diameter+2+tolerance/2, $fn=4);
 
        }
    
   
    #translate([0,4.9,-1]) cube([gear3_x+pin_diameter,4.3,1.9]);
    translate([0,4.9,-1]) cube([10,gear5_y+pin_diameter-4.9,1.9]);
}
module support_with_hole() {
  difference() {
      support();
     translate([10,20,-2]) cube([5,20,10]);
  }
}

support_with_hole();
mirror([1,0,0]) support_with_hole() ;
!translate([0,0,thickness+3]) {
    support_top();
    mirror([1,0,0]) support_top();
}