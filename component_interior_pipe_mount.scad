$fn=100;

// Metric pipe system refers to *outside* diameter
// Wall thickness of 15mm pipe is 0.7mm so internal diameter is (15 - (0.7 x 2 )) = 13.6mm
// Wall thickness of 22mm pipe is 0.9mm so internal diameter is 20.2mm
// Imperial pipe system refers to *inside* diameter
// 1/2" pipe has an internal diameter of 12.7mm
// 3/4" pipe internal diameter is 19.05 mm.

// When pipes get cut, the edges tend to get squished inwards, so you might
// want to reduce diameter slightly
pipe_inside_diameter = 13.5;

mount_height = 6;

// width, height, depth, distance between pins
ldr_dimensions = [5.2,4.3,2,3.4];
// diameter, depth, distance between pins
led_dimensions = [5.9,3,2.54]; // 5mm LED is 5.9mm including base

difference(){
  cylinder(d=pipe_inside_diameter, h=mount_height);
  ldr();
}

module ldr() {
  translate([-ldr_dimensions[0]/2,0,0]){
    scale = .85;
    linear_extrude(ldr_dimensions[2]){
      hull(){
        translate([ldr_dimensions[1]/2*scale,0,0])
          scale([scale,1,1])
            circle(d=ldr_dimensions[1]);
        translate([ldr_dimensions[0]-ldr_dimensions[1]*scale/2,0,0])
          scale([scale,1,1])
            circle(d=ldr_dimensions[1]);
      }
    }
    translate([ldr_dimensions[0]/2-ldr_dimensions[3]/2,0,0])
      cylinder(r=0.6, h=30);
    translate([ldr_dimensions[0]/2+ldr_dimensions[3]/2,0,0])
      cylinder(r=0.6, h=30);
  }
}


module led() {
  linear_extrude(led_dimensions[1]){
    circle(d=led_dimensions[0]);
  }
  translate([-led_dimensions[2]/2,0,0])
    cylinder(r=0.6, h=20);
  translate([led_dimensions[2]/2,0,0])
    cylinder(r=0.6, h=20);
}
