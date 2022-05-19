
$fn=100;

module branch(circle_diameter, lenght, thickness, with_holde=false, step = 0.1) {
    middle = lenght/2;

    points = [
        for (i = [0:0.1:lenght]) [i,(2*((i/lenght)-0.5)^2+0.5)*circle_diameter],
        for (i = [lenght:-0.1:0])  [i,-(2*((i/lenght)-0.5)^2+0.5)*circle_diameter]
    ];
    linear_extrude(thickness) difference() {
        union() {
            polygon(points); 
            circle(circle_diameter); 
            translate([lenght,0]) circle(circle_diameter);
        }
        if (with_holde) {
            circle(circle_diameter/2); 
            translate([lenght,0]) circle(circle_diameter/2);
        }
    }
}
