id = 15;          // inner diameter of ring
od = 18;          // outer diameter of ring
height = 10;      // height of ring
gap = 90;         // ring opening in degrees
ends=1;           // 0 no ends, 1 round ends, 2 clamp ends
hd=3.5;           // mount hole diameter
cd=7;             // countersink diameter
cdepth=2;         // coutersink depth
blobsize=1;       // size of rounded ends, if ends==1
sw=12;            // mounting block width
sdepth=4;        // support depth
nholes=0;         // number of support holes.
block_holes=[0];   // block some holes e.g. [2,3]
sh=10;            // mounting block height. NB total height is nholes x height.
support_loc=0;    // 0 = mounting block is centered, >0 centred on hole number
support_rot=0;    // support angle / clamp angle.
flat_bottom=false; //remove all points below the bottom of the ring for ease of printing
clamp_width=5;   // width of clamp ends
clamp_depth=10;   // depth of clamp ends
clamp_height=10;  // height of clamp ends
clamp_hole=3;     // diameter of clap screw hole
clamp_holew=1;    // clamp hole width

// internal constants
$fn=100;
g=1/(nholes+1);
fracs=[for (i=[g:g:(1-g)]) each i];
sh2=sh+cd;



led_spacing = [1000/30, 1000/60, 1000/144];

 //main();

LED_pipe_clip();

module LED_pipe_clip(length = 66.6667) {

num_clips=3;
  led_channel_outside_width = 14;
  led_channel_inside_width = 10;
  led_channel_height = 4;

  difference() {
    union() {
      difference() {
        // Outside cylinder around pipe
        cylinder(h=length, d=od);
        // Interior cutout of cylinder
        cylinder(h=length+0.1, d=id);
        // Cut-off back side
        translate([0,-od/2,0]) {
            cube([od,od,length+0.1]);
        }
      }
      // LED sheath
      translate([-id/2-led_channel_height+2, -od/2 + (od-led_channel_outside_width)/2, 0]) {
        cube([led_channel_height,led_channel_outside_width,length]);
      }
      // Clips
      for(i= [0 : num_clips-1]) {
        translate([0,0,(length-((num_clips-1)*height))/(num_clips-1)/2+            i*led_spacing[1]+(height/2)]) {
          main();
        }
      }
    }
    // Cutout interior channel of LED sheath
    translate([-od/2+1,-led_channel_inside_width/2,0])
      cube([3,led_channel_inside_width,length+0.1]);
 
    for(i= [0 : num_clips-1]) {
      translate([0,0,(length-((num_clips-1)*height))/(num_clips-1)/2+            i*led_spacing[1]+(height/2)]) {
          //LED
          translate([-id/2-0.01, 0, 0])
          cube([4, 5.5,5.5], center=true);
          //Capacitor
          translate([-id/2 -.5, 0, (5.5+2.4)/2])
          cube([2, 3,2.4], center=true);
        }
    }
    
  }
}
/*

*/

/*



/*
  difference() {  
    

    }
  }

  difference() { 

      
      
    }
*/



/*
difference(){

  union() {
    difference() {
      union() {
        // Outside cylinder around pipe
        cylinder(h=33.3+10, d=od);
        // LED sheath
        translate([-od+6,-od/2 + (od-12)/2,0])
          cube([6,12,33.3+10]);
      }
      // Interior cutout of cylinder
      cylinder(h=33.3+0.1+10, d=id);
      translate([0,-od/2,0]) {
        cube([od,od,33.3+0.1+10]);
      }
    }

    %for(i= [0 : 2]) {
      translate([0,0,i*led_spacing[1] + height/2]) {
        difference() {
          main();
          //LED
          translate([-id/2 -3/2, 0, 0])
          cube([8, 5.5,5.5], center=true);
          //Capacitor
          translate([-id/2, 0, (5.5+2.4)/2])
          cube([8, 3,2.4], center=true);
        }
      }
    }
  }

}
*/

module main() {
    difference() {
        union(){
            // the clip
            clip();
            // mounting block
            if (nholes>0) {
            rotate([support_rot,0,0]) {
                if (support_loc==0) { //center    
                    translate([0,0,-(sh/2)*(nholes-1)]){
                        support_block();
                    }
                } else {
                    translate([0,0,-sh*(support_loc-1)]){
                        support_block();
                    }
                }
            }
        }
        }
        if(nholes>0){
        // holes go through clip and mounting block
        rotate([support_rot,0,0]) {
            if (support_loc==0) { //center
                    translate([0,0,-(sh/2)*(nholes-1)]){
                        holes();
                    }
            } else {
                translate([0,0,-sh*(support_loc-1)]){
                    holes();
                }
            }
        }
    }
        //flat bottom
        if (flat_bottom) {
            translate([0,0,-(od+sh)-height/2]) {
                cube(2*(od+sh),center=true);
            }
        }
    }
} //main


module end_blobs(h,d,angle,od,center=false) {
translate([od,0,0]){
    cylinder(h=h,d=d,center=center);
}
rotate([0,0,angle]) {
    translate([od,0,0]){
        cylinder(h=h,d=d,center=center);
    }
}
} //end_blobs

module end_clamps(){
    translate([id/2+clamp_depth/2+(od-id)/4,-clamp_width/2,0]){
        difference(){
            cube([clamp_depth,clamp_width,clamp_height],center=true);
            translate([-clamp_holew/2,0,0]) {
                rotate([90,0,0]){
                    cylinder(d=clamp_hole,h=clamp_width+2,center=true);
                }
            }
            translate([clamp_holew/2,0,0]) {
                rotate([90,0,0]){
                    cylinder(d=clamp_hole,h=clamp_width+2,center=true);
                }
            }
            cube([clamp_holew,clamp_width+2,clamp_hole],center=true);
        }
    }
    
    rotate([0,0,gap]) {
    translate([id/2+clamp_depth/2+(od-id)/4,clamp_width/2,0]){
        difference(){
            cube([clamp_depth,clamp_width,clamp_height],center=true);
            translate([-clamp_holew/2,0,0]) {
                rotate([90,0,0]){
                    cylinder(d=clamp_hole,h=clamp_width+2,center=true);
                }
            }
            translate([clamp_holew/2,0,0]) {
                rotate([90,0,0]){
                    cylinder(d=clamp_hole,h=clamp_width+2,center=true);
                }
            }
            cube([clamp_holew,clamp_width+2,clamp_hole],center=true);
        }
    }
}
}

module wedge(h,d,angle,center=false) {
intersection(){
    cylinder(h=h,d=d,center=center);
    x = (sqrt(2*(d^2))/2)+1;
    y = 0;
    xr = x*cos(angle)-y*sin(angle);
    yr = x*sin(angle)+y*cos(angle);

    linear_extrude(h*2,center=center){
        if (angle<=90){
            polygon([[x,0],[xr,yr],[0,0]]);
        } else if (angle<=180) {
            polygon([[x,0],[0,x],[xr,yr],[0,0]]);
        } else if (angle<=270) {
            polygon([[x,0],[0,x],[-x,0],[xr,yr],[0,0]]);
        } else {
            polygon([[x,0],[0,x],[-x,0],[0,-x],[xr,yr],[0,0]]);
        }
    }
}
} //wedge

module support_block() {   
for (k = [g:g:(1-g)]) { 
    offset=sh*((k-g)/g);
    translate([-(sdepth/2)-id/2,0,offset]){
        cube([sdepth,sw,sh],center=true);
    }
}
} //support_block

module clip(){
    rotate([0,0,-gap/2]){
        difference() {
            cylinder(h=height,d=od,center=true);
            cylinder(h=height*2,d=id,center=true);
            wedge(h=height*2,d=od+1,center=true,angle=gap);
        }
        if (ends==1) {
            end_blobs(h=height,d=((od-id)/2)+blobsize,angle=gap,od=(id+(od-id)/2)/2,center=true);
        }
        if (ends==2) {
            end_clamps();
        }
    }

} //clip

module holes(){
  
for (f = [1:nholes]) {
    k=fracs[f-1];
    if (len(search(f,block_holes))==0) {
        offset=sh*((k-g)/g);
        translate([-(sdepth/2)-id/2,0,offset]){
        // mount holes
        rotate([0,90,0]){
            cylinder(h=2*sdepth,d=hd,center=true);
        }
        // countersink
        translate([sdepth/2-cdepth,0,0]){
        rotate([0,90,0]){
            cylinder(h=2*sdepth,d=cd);
        }
    }
}
}
}
}

