// Nominal diameter of the ball
ballDiameter = 24;

// Nominal diameter of the socket
socketDiameter = 24;
// Wall thickness of the socket
socketWall = 4;
outerDiameter = socketDiameter + (socketWall*2);
socketCutDepthFactor = 0.35;
// Depth of the cut made into the socket sphere in relation to the full OD
socketCutDepth = outerDiameter * socketCutDepthFactor;
// Relief cut depth relative to socket cut plane
socketReliefDepth = 15;
// Number of socket relief cuts
socketReliefs = 8;
// Width of the socket relief cuts
socketReliefWidth = 1.5;
internalReliefXOffset = 0.75;
internalReliefZOffset = (socketDiameter / 2) * 0.9;
internalReliefDiameter = 3.5;

// Girth of the shaft
shaftDiameter = 14;
// Length of the shaft
shaftLength = 30;
// Diameter of the ring capture notch cut into the socket
ringNotchDiameter = 3.0;
// Tune this to change the ring notch cut depth, more +offset = shallower
ringNotchOffset = ringNotchDiameter / 6;
// P hole diameter
pHoleDiameter = 2.8;
// P hole countersink diameter
pHoleCountersinkDiameter = 8;
// P hole countersink depth
pHoleTipCountersinkDepth = 1.0;
pHoleSocketCountersinkDepth = 1.0;

// Preview mode (faster, visualizes cuts but does not perform them)
previewDingus = false;
enablePHole = true;
enableReliefCuts = true;
enableInternalReliefs = true;
enableExternalCuts = true;

// Z-level of the end of the dingus
tip = shaftLength+ballDiameter/2;
// Z-level of the base of the dingus after the socket cut
base = -(outerDiameter/2) + socketCutDepth;

socketCutPlane = (-1/2 * outerDiameter) + socketCutDepth;
cutColor = "white";

$fn = 16;

function chordLength(r, t) = 2 * sqrt(abs(r)^2 - abs(t)^2);
// Calculate chord given diameter and offset from center, returns 1/2 chord length
function radialChord(d, t) = sqrt(abs(d/2)^2 - abs(t)^2);

module dingus() {
    union() {
        // Construct the basic dingus
        // Shaft
        color("skyblue", 1)
        cylinder(h = shaftLength, d=shaftDiameter);
        // Ball
        color("skyblue", 1)
        translate([0, 0, shaftLength])
            sphere(d=ballDiameter);
        // Socket
        color("skyblue", 1)
        sphere(d=outerDiameter);    
    }
};

module socketCut() {
    // Cut the bottom off the base sphere (socket)
    translate([0, 0, -outerDiameter/2 + socketCutPlane])
    color(cutColor, 0.25)
    cube([outerDiameter + 1, outerDiameter + 1, outerDiameter], center=true);    
    // Cut the socket internal volume
    color("lime", 1)
    sphere(d=socketDiameter, $fn=100);
}

module reliefCuts() {
    // Cut reliefs around the socket
    for(r = [0 : 360/socketReliefs : 360]) {
        rotate([0, 0, r])
        translate([-1 * (socketReliefWidth/2), 0, socketCutPlane])
        color(cutColor, 0.25)
        cube([socketReliefWidth, socketDiameter/2+socketWall+4, socketReliefDepth]);
    }    
}

module internalReliefCuts() {
    // Cut internal reliefs
    color("orange", 1)
    rotate_extrude(convexity=3)
    translate([radialChord(socketDiameter, internalReliefZOffset)-internalReliefXOffset, internalReliefZOffset, 0])
    circle(d=internalReliefDiameter);
    
    color("orange", 1)
    rotate_extrude(convexity=3)
    translate([radialChord(socketDiameter, internalReliefZOffset/1.5)-internalReliefXOffset, internalReliefZOffset/1.5, 0])
    circle(d=internalReliefDiameter);
    
    color("orange", 1)
    rotate_extrude(convexity=3)
    translate([radialChord(socketDiameter, internalReliefZOffset/9)-internalReliefXOffset, internalReliefZOffset/9, 0])
    circle(d=internalReliefDiameter);      
}

module externalCuts() {

    // Cut the ring capture notch
    color(cutColor, 0.25)
    rotate_extrude(convexity=3)
    translate([outerDiameter/2+ringNotchOffset, -2, 0])
    circle(d=ringNotchDiameter);
    // Cut the ring capture notch
    
    color(cutColor, 0.25)
    rotate_extrude(convexity=3)
    translate([outerDiameter/2+ringNotchOffset, 2, 0])
    circle(d=ringNotchDiameter);    
        
    // Cut socket edge concave
    color("red", 0.25)
    rotate_extrude(convexity=3)
    translate([radialChord(socketDiameter, socketCutPlane), socketCutPlane, 0])
    circle(d=ringNotchDiameter);    
    

}

module pHoleCuts() {
    // Passthrough hole
    color(cutColor, 0.5)
    linear_extrude(tip+1)
    circle(d=pHoleDiameter);
    
    // Socket countersink
    color("cyan", 0.25)
    linear_extrude((socketDiameter/2) + pHoleSocketCountersinkDepth)
    circle(d=pHoleCountersinkDiameter);
    
    // Tip countersink
    color("gold", 0.25)
    translate([0, 0, tip-pHoleTipCountersinkDepth])
    linear_extrude(pHoleTipCountersinkDepth*2)
    circle(d=pHoleCountersinkDiameter);
}

if(previewDingus) {
    difference() {
        dingus();
        socketCut();
    }
    pHoleCuts();
    externalCuts();
    internalReliefCuts();
}
else {
    difference() {
        difference() { 
            difference() {
                dingus();
                socketCut();
            }
            if(enablePHole) 
            pHoleCuts();
            if(enableExternalCuts)
            externalCuts();
            if(enableInternalReliefs)
            internalReliefCuts();
        }
        if(enableReliefCuts)
        reliefCuts();
    }    
}