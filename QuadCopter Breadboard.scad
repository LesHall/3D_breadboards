// by Les Hall
// Mon May 15 2017
// 



// parameters
selection = 0;  // which module to display / print
numMotors = 4;  // number of motors on quadcopter
armLength = 50;  // length of quadcopter arms
dims_ATtiny = [11, 2];  // [rows, cols]
spacing = 2.54;  // distance between holes
thickness = 8.5;  // thickness of breadboard, bottom to top
holes = 5;  // number of horizontal holes



// create the object
object();
module object() {
    
    if (selection == 0)
        rotate([0, 180, 0])
        system(dims_ATtiny);
    
    else if (selection == 1)
        rotate([0, 180, 0])
        structure([4, 2]);
}



// this is the view of all parts positioned separately
module system(dims) {
    
    // draw the arms of the quadcopter
    for (i = [0:numMotors-1])
        rotate(360 * i/numMotors)
        translate([armLength/2 + dims[1] * (holes+1) * spacing/2, 0, 0])
        arm(armLength);
    
    // the breadboard at the center position
    structure(dims);
    
    // the breadboards at the motor positions
    for (i = [0:numMotors-1])
        rotate(360 * i/numMotors)
        translate([armLength + 3/2 * (holes+1) * spacing, 0, 0])
        structure([2, 1]);
}



// one arm
module arm(L) {
    
    translate([0, 0, thickness/2])
    cube([L, 2*spacing, thickness], center = true);
}



// the frame, or shape, of the breadboard
// into which the clips are inserted
module structure(dims) {
    
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
    for (dx = [1:holes])
        translate([dx*spacing, spacing, 0])
        cube([spacing/2, spacing/2, 2*thickness], center = true);
    
    // chisel for gripper
    translate([(holes+1)*spacing/2, spacing, 6.75/2])
    cube([holes*spacing, spacing/2, 6.75], center = true);
}


