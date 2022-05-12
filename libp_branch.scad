/*
a = [
    for (i = [0:0.1:10]) [i,-2-(-(10/(i+1))/7)],
    for (i = [10:-1:0])  [i,+2]
];
    */
$fn=100;

module branch(circle_diameter, lenght, thickness, step = 0.1) {
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
        circle(circle_diameter/2); 
        translate([lenght,0]) circle(circle_diameter/2);
    }
}