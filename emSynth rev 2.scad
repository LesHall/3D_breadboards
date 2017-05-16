// 
// emSynth, the electro-music.com synthesizer
// featuring optical interconnect and fuzzy logic gates
// 
// by Les Hall
// Mon May 15 2017
// 
// term "UGen (Unit Generator" from the ChucK music programming language
//       http://chuck.cs.princeton.edu/
// 



// parameters
selection = 0;  // which module to display / print
numLED = 4;  // number of LEDs on breadboard
armLength = 50;  // length of quadcopter arms
dims_ATtiny = [11, 2];  // [rows, cols]
spacing = 2.54;  // distance between holes
thickness = 8.5;  // thickness of breadboard, bottom to top
holes = 5;  // number of horizontal holes



// create the object
object();
module object() {
    
    if (selection == 0)
        
        // one Unit Generator breadboard object, upside down for printability
        rotate([0, 180, 0])  // flip upside down
        UGen(dims_ATtiny);  // draw one system
    
    else if (selection == 1)
        rotate([0, 180, 0])
        array([4, 2]);
}



// this is the view of all parts positioned separately
module UGen(dims) {
    
    // the breadboard at the center position
    array(dims);
    
    // the peripheral LED holders
    for (LED = [0:numLED-1]) {
        rotate(360 * LED/numLED)
        translate([0, -((dims[0]+1)/2) * spacing, thickness - spacing]) {
            
            // the LED holders
            translate([0, -thickness, 0])
            rotate([90, 0, 0])
            array([1,2]);
            
            // the connecting pieces
            translate([0, -thickness/2, 0])
            difference() {
                
                // positive material, a solid box
                cube([dims[1] * (holes+1) * spacing, 
                    thickness, dims[1] * spacing], 
                    center = true);
                
                // negative material (or "chisel"), a smaller offset solid box
                for (side = [-1:2:1]) {
                    translate([side * (holes+1)/2 * spacing, 0, 
                        -spacing*(1+1/16)])
                    cube([dims[1]/2 * (holes+1.125) * spacing, 
                        thickness, 
                        (dims[1]+1) * spacing] + [-1/2, 0, 0] * spacing, 
                        center = true);
                }
            }
        }
    }
}



// the frame, or shape, of the breadboard
// into which the clips are inserted
module array(dims) {
    
    translate([-dims[1]/2 * (holes+1) * spacing, -(dims[0]+1)/2 * spacing, 0])
    difference() {
        
        // main shape of breadboard
        cube([dims[1] * (holes + 1) * spacing, (dims[0]+1) * spacing, thickness]);
        
        // holes in top
        for (rows = [0:dims[0]-1], cols = [0:dims[1]-1])
            translate([cols*(holes+1)*spacing, rows*spacing, 0])
            gripper();
    }
}



module gripper() {
    
    // chisels for holes
    for (dx = [1:holes]) {
        translate([dx*spacing, spacing, thickness/2]) {
            
            // the vertical channel
            cube([1, 1, thickness], center = true);
        
            // the chamfers to help guide pins into holes
            translate([0, 0, thickness/2])
            rotate(45)
            cylinder(h = 4*sqrt(2), d1 = 0, d2 = 4*sqrt(2), 
                center = true, $fn = 4);
        }
    }
    
    // chisel for gripper
    translate([(holes+1)*spacing/2, spacing, thickness/2])
    cube([14.25, 2.25, 6.75], center = true);
}


