// Nominal diameter of the ball
ballDiameter = 24;
// Girth of the shaft at the knob
shaftDiameter = 8;
// Length of the shaft
shaftLength = 30;
// Diameter of the flange
flangeDiameter = 40;
// Thickness of the flange
flangeThickness = 6;
// Flange Hole diameter
flangeHoleDiameter = 4;
// Flange Countersink Diameter
flangeCountersinkDiameter = 6;
// Flange Countersink Depth
flangeCountersinkDepth = 1;

shaftBaseDiameter = flangeDiameter - (flangeCountersinkDiameter * 2) - (flangeDiameter / 10);

// Preview mode (faster, visualizes cuts but does not perform them)
previewDingus = true;

// Z-level of the end of the dingus
tip = shaftLength+ballDiameter/2;

cutColor = "white";

$fn = 25;

function chordLength(r, t) = 2 * sqrt(abs(r)^2 - abs(t)^2);
// Calculate chord given diameter and offset from center, returns 1/2 chord length
function radialChord(d, t) = sqrt(abs(d/2)^2 - abs(t)^2);

module dingus() {
    union() {
        // Construct the basic dingus
        // Shaft
        color("skyblue", 1)
        cylinder(h = shaftLength, d1=shaftBaseDiameter, d2 = shaftDiameter);
        // Ball
        color("skyblue", 1)
        translate([0, 0, shaftLength])
            sphere(d=ballDiameter);  
    }
};

module flange() {
    difference() {
        translate([0, 0, -flangeThickness])
        cylinder(flangeThickness, d = flangeDiameter);
        union() {
        for(r = [0 : 360/4 : 360]) {
            rotate([0, 0, r]) {
                translate([flangeDiameter/2 - flangeHoleDiameter, 0, -flangeThickness]) {
                    cylinder(h = 10, d=flangeHoleDiameter);
                }
                translate([flangeDiameter/2 - flangeHoleDiameter, 0, -flangeCountersinkDepth]) {
                    cylinder(h = flangeCountersinkDepth+0.1, d1=flangeHoleDiameter, d2=flangeCountersinkDiameter);
                }
            }
        }
    }
}
}


if(previewDingus) {
        dingus();
        flange();
}
else {
    dingus(); 
}