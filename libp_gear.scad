function getAddendum(toothHeight) = toothHeight*1/2.25;
function getDedendum(toothHeight) = toothHeight*1.25/2.25;

function getPitchRadiusFromTeeth(toothThickness, numberOfTeeth) =
        (toothThickness*numberOfTeeth)/PI;
        
function getBaseRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight) = 
        getPitchRadiusFromTeeth(toothThickness, numberOfTeeth) - getDedendum(toothHeight) ;

function getFullRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight) = 
        getPitchRadiusFromTeeth(toothThickness, numberOfTeeth) + getAddendum(toothHeight) ;
        
function getRootRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight) = 
        sqrt((getBaseRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight)^2)+((toothThickness/2)^2));

function getRackLenght(toothThickness, numberOfTeeth) =
        (numberOfTeeth-1)*toothThickness*2+toothThickness;
        
function getFullrackWidth(rackWidth, toothHeight) =
        rackWidth + getAddendum(toothHeight);
        
function getSolidrackWidth(rackWidth, toothHeight) =
        rackWidth - getDedendum(toothHeight);

module tooth(toothThickness, toothHeight, thickness, tolerance=0) {
    addendum = getAddendum(toothHeight);
    dedendum = getDedendum(toothHeight);
    
    toothThickness=toothThickness-tolerance;
    
    addendumRatio=3;
    addendumThickness = toothThickness/addendumRatio;
    
    translate([0,-toothThickness/2,0]) {
        hull() {
            translate([-dedendum,0,0]) cube([dedendum,toothThickness,thickness]);
            translate([0,toothThickness/2-addendumThickness/2,0]) cube([addendum-tolerance,addendumThickness,thickness]);
        }
    }
}

module gear(toothThickness, numberOfTeeth, toothHeight, thickness, tolerance=0) {
    pitchRadius = getPitchRadiusFromTeeth(toothThickness, numberOfTeeth);
    rootRadius = getRootRadiusFromTeeth(toothThickness, numberOfTeeth, toothHeight);
    union() {
        for(i=[0:numberOfTeeth])
            rotate([0,0,i*360/numberOfTeeth])
                translate([pitchRadius,0,0])
                    tooth(toothThickness, toothHeight, thickness, tolerance);
        cylinder(thickness, r=rootRadius, $fn=100);
    }
}

module rack(toothThickness, numberOfTeeth, toothHeight, rackWidth, thickness, tolerance=0) {
    rackLenght=getRackLenght(toothThickness,numberOfTeeth);
    union() {
        for(i=[0:numberOfTeeth-1]) 
            translate([0,i*toothThickness*2,0])
                translate([rackWidth,toothThickness/2,0]) 
                    tooth(toothThickness, toothHeight, thickness, tolerance);
        cube([rackWidth-getDedendum(toothHeight),rackLenght,thickness]);
        }
}

function gearPosition(angle, 
                      toothThickness, 
                      currentGear_numberOfTeeth, 
                      relativeGear_numberOfTeeth, 
                      relativeGear_x,
                      relativeGear_y) = 
    [relativeGear_x + (getPitchRadiusFromTeeth(toothThickness, currentGear_numberOfTeeth)+getPitchRadiusFromTeeth(toothThickness, relativeGear_numberOfTeeth))*cos(angle),
    relativeGear_y + (getPitchRadiusFromTeeth(toothThickness, currentGear_numberOfTeeth)+getPitchRadiusFromTeeth(toothThickness, relativeGear_numberOfTeeth))*sin(angle)];
