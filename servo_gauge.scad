// Smoothing parameter
$fn = 100;

// Gauge parameters
gauge_od = 60;
gauge_wall_thickness = 2;
gauge_height = 20;

// Call this function to render all parts
render_all();

module render_all() {
    // Servo model
  translate([-23/2+5.9,0,16 - 4])
  9g_motor();
  
  // Main housing for the servo
  translate([-23/2+5.9,0,-20])
    color("grey")
    servomount();
  
  // The disc mounted to the front of the servo that will show the dial graphic
  translate([0,0,43.5])
    color("white")
    dial_plate();

  // The mount to secure the acrylic
  // Translate upwards by height of base + thickness of glass front
  translate([0,0,75])
  rotate([180,0,0])
  color("grey", 0.8)
    front_cover_holder();
}

// Create the plate that will be placed on top of the servo
// and have the indicator dial display printed on it.
module dial_plate() {
  // Allowance to make sure disc definitely fits inside the tube
  rim_fudge = 0.4;
  
  difference() {
    union() {
      translate([0,0,3])
        cylinder(h=1, d=gauge_od - (gauge_wall_thickness*2) - rim_fudge);   
      translate([-5.5,0,0])
        cube([36,18,8],center=true);
    }
  translate([-5.5,0,-11])
    9g_motor();

  for ( hole = [8.5,-19.5] ){
			translate([hole,0,5]) cylinder(r=1.5, h=20, $fn=20, center=true);
		}    
  }  
}

// This holds the acrylic screen protector on the front
module front_cover_holder() {
  front_thickness = 1;
  outside_rim_thickness = 2;
  // reduce this for a tighter fit
  rim_fudge = 0.05;
  difference() {
    cylinder(h=8, d=gauge_od + outside_rim_thickness);
    translate([0,0,front_thickness])
      cylinder(h=10, d=gauge_od + rim_fudge);
    translate([0,0,-0.01])
      cylinder(h=10, d=gauge_od - 3);  
  }
}

module servomount() {
  outside_rim_height = 5;
  outside_rim_thickness = 2;
  inside_rim_height = 4;
  inside_rim_thickness = 1;
  // The thickness of the back of the dial
  back_thickness = 2;
  rim_fudge = 0.2;
  // The default height gives room for the servo to either be inserted
  // onto the top of the mount, or pushed through from underneath.
  // If you'd like only one of these, you can reduce the height.
  // Value of -5 means a servo pushed down from above just rests flush on the base.
  servo_height_adjust = -4;

  difference() {
    union() {
      translate([23/2-5.9,0,0]) {
        // Use this to create a tube
        // Make sure it is tall enough to accommodate the servo and needle
        difference() {
          cylinder(h=32, d=gauge_od);
            translate([0,0,back_thickness])
              cylinder(h=32, d=gauge_od - (gauge_wall_thickness*2));  
        }
      }
      // Main mount box
      translate([0,0,(20+servo_height_adjust)/2])
        cube([36,18,20+servo_height_adjust], center=true);
    }
    // Screw holes
    translate([23/2-5.9,0,0]) {
      for(x=[15,-15], y=[14,-14]) {
        translate([x, y, 1]) {
          cylinder(r2=4,r1=2,h=2);
          cylinder(r=2,h=4,center=true);
        }
      }
    }
    // Cutout in base
    translate([0,0,(20+servo_height_adjust)/2-4])
      cube([33,12.6,20+servo_height_adjust],center=true);
    // Cutout cable channel
    translate([12,0,16+servo_height_adjust])
      cube([1.5,5,40],center=true);
    // Cutout Servo model
    translate([0,0,16+servo_height_adjust]) {
      9g_motor();
      }
    // Cutout Servo screw holes
    for(hole = [-14,14] ){
			translate([hole,0,16+servo_height_adjust])
        cylinder(r=1, h=12, $fn=32, center=true);
		}
  }
}

module 9g_motor(){
	difference(){			
		union(){
			color("blue") cube([23,12.5,22], center=true);
			color("blue") translate([0,0,5]) cube([32,12,2], center=true);
			color("blue") translate([5.5,0,2.75]) cylinder(r=6, h=25.75, $fn=100, center=true);
			color("blue") translate([-.5,0,2.75]) cylinder(r=1, h=25.75, $fn=20, center=true);
			color("blue") translate([-1,0,2.75]) cube([5,5.6,24.5], center=true);		
			color("white") translate([5.5,0,3.65]) cylinder(r=2.35, h=29.25, $fn=20, center=true);				
		}
		for ( hole = [14,-14] ){
			translate([hole,0,5]) cylinder(r=2.2, h=4, $fn=20, center=true);
		}	
	}
}