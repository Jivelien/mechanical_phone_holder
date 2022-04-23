module tooth(baseCircleRadius, numberOfTeeth, toothHeight, thickness) {
    pitch = (baseCircleRadius*PI)/numberOfTeeth - tolerance;
    addendum = toothHeight*1/2.25;
    dedendum = toothHeight*1.25/2.25;
    
    translate([0,-pitch/2,0])
    hull() {
        // base cube
        translate([-dedendum,0,0]) cube([dedendum, pitch, thickness]);
        //top cube
        translate([0-tolerance,((pitch)-(pitch/2))/2,0])cube([addendum,pitch/2,thickness]);
    }
}
    
module gear(baseCircleRadius, numberOfTeeth, toothHeight, thickness) {
    pitch = (baseCircleRadius*PI)/numberOfTeeth - tolerance;
    addendum = toothHeight*1/2.25;
    dedendum = toothHeight*1.25/2.25;
    echo("----------------------------");
    echo("Teeth:",numberOfTeeth);
    echo("pitch:",pitch);
    echo("radius:",baseCircleRadius);
    
    union() {
        for(i=[0:numberOfTeeth])
            rotate([0,0,i*360/numberOfTeeth])
            translate([baseCircleRadius,0,0]) tooth(baseCircleRadius, numberOfTeeth, toothHeight, thickness);
        cylinder(thickness, r=baseCircleRadius-dedendum*0.8, $fn=100);
    }
}

module rack(baseCircleRadius, numberOfTeeth, toothHeight, thickness, numberOrTeethForRack, rackHeight) {
    addendum = toothHeight*1/2.25;
    dedendum = toothHeight*1.25/2.25;
    pitch = ((baseCircleRadius)*PI*2)/numberOfTeeth;
    
    translate([-rackHeight,0,0]) cube([rackHeight-dedendum, numberOrTeethForRack*pitch, thickness]);
    for (i=[0:numberOrTeethForRack-1])
        translate([0,i*pitch+pitch/2,0])
            tooth(baseCircleRadius, numberOfTeeth, toothHeight, thickness);
        
}