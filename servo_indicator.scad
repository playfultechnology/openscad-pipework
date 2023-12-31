/**
 *  Parametric servo arm generator for OpenScad
 *  Générateur de palonnier de servo pour OpenScad
 *
 *  Copyright (c) 2012 Charles Rincheval.  All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  Last update :
 *  https://github.com/hugokernel/OpenSCAD_ServoArms
 *
 *  http://www.digitalspirit.org/
 */
 
 //https://www.rcgroups.com/forums/showpost.php?p=13441675&postcount=2
 
$fn = 40;

/**
 *  Clear between arm head and servo head
 *  With PLA material, use clear : 0.3, for ABS, use 0.2
 */
SERVO_HEAD_CLEAR = 0.2;

/**
 *  Head / Tooth parameters
 *  Futaba 3F Standard Spline
 *  http://www.servocity.com/html/futaba_servo_splines.html
 *
 *  First array (head related) :
 *  0. Head external diameter
 *  1. Head heigth
 *  2. Head thickness
 *  3. Head screw diameter
 *
 *  Second array (tooth related) :
 *  0. Tooth count
 *  1. Tooth height
 *  2. Tooth length
 *  3. Tooth width
 */
FUTABA_3F_SPLINE = [
  [5.92, 4, 1.1, 2.5],
  [25, 0.3, 0.7, 0.1]
];
// White plastic head
MICRO_SG90_SPLINE = [
  [4.68, 3, 1.2, 2.5],
  [21, .45, 0.7, 0.1]
];
// Metal head
MICRO_MG90S_SPLINE = [
  [4.68, 4, 1.0, 2.5],
  [20, .8, 0.7, 0.1]
];
// White plastic head, continuous rotation
MICRO_FS90R_SPLINE = [
  [4.68, 3, 1.2, 2.5],
  [21, .45, 0.7, 0.1]
];

// rotate([0, 180, 0])
// Config, Length, Number of Arms
servo_horn(MICRO_SG90_SPLINE, [24, 1]);


/**
 *  Servo horn
 *  - Head / Tooth parameters
 *  - Arms params (length and count)
 */
module servo_horn(params, arms) {

  head = params[0];
  tooth = params[1];

  head_diameter = head[0];
  head_height = head[1];
  head_thickness = head[2];
  head_screw_diameter = head[3];

  tooth_length = tooth[2];
  tooth_width = tooth[3];

  arm_length = arms[0];
  arm_count = arms[1];

  // Head
  difference() {
    translate([0, 0, 0.1]) {
      cylinder(r = head_diameter / 2 + head_thickness, h = head_height + 1);
    }
    cylinder(r = head_screw_diameter / 2, h = 10);
    servo_head(params);
  }
  // Arm
  translate([0, 0, head_height]) {
    for (i = [0 : arm_count - 1]) {
      rotate([0, 0, i * (360 / arm_count)]) {
        servo_arm(arm_length, head_diameter + head_thickness * 2, head_height, 2);
      }
    }
  }


  /**
   *  Servo head submodule
   */
  module servo_head(params, clear = SERVO_HEAD_CLEAR) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_height = head[1];

    tooth_count = tooth[0];
    tooth_height = tooth[1];
    tooth_length = tooth[2];
    tooth_width = tooth[3];

    % cylinder(r = head_diameter / 2, h = head_height + 1);

    cylinder(r = head_diameter / 2 - tooth_height + 0.03 + clear, h = head_height);

    for (i = [0 : tooth_count]) {
      rotate([0, 0, i * (360 / tooth_count)]) {
        translate([0, head_diameter / 2 - tooth_height + clear, 0]) {
          servo_head_tooth(tooth_length, tooth_width, tooth_height, head_height);
        }
      }
    }
    
     /**
     *  Tooth
     *
     *  |<-w->|
     *  |_____|___
     *  /   \  ^h
     *  _/     \_v
     *   |<--l-->|
     *
     *  - tooth length (l)
     *  - tooth width (w)
     *  - tooth height (h)
     *  - height
     *
     */
    module servo_head_tooth(length, width, height, head_height) {
      linear_extrude(height = head_height) {
        polygon([[-length / 2, 0], [-width / 2, height], [width / 2, height], [length / 2,0]]);
      }
    }
  }

  /**
   *  Servo arm
   *  - length is from center to last hole
   */
  // hole_count had been hard-coded as 1 previously
  module servo_arm(tooth_length, tooth_width, reinforcement_height, head_height, hole_count = 0) {
    arm_screw_diameter = 2;

    // This had been hard-coded at 2 previously
    arm_start_width = 4;
    // This value was hard-coded at 3 previously
    reduction_factor= 20;
    tail_length = 8;

    difference() {
      union() {
        // The start of the arm above the servo shaft
        cylinder(r = tooth_width / 2, h = head_height);

        // The main shaft of the arm
        linear_extrude(height = head_height) {
          polygon([
            [-tooth_width / arm_start_width, 0], [-tooth_width / reduction_factor, tooth_length],
            [tooth_width / reduction_factor, tooth_length], [tooth_width / arm_start_width, 0]
          ]);
        }

        // The "tail" shaft of the arm
        linear_extrude(height = head_height) {
          polygon([
            [-tooth_width / arm_start_width, -tail_length], [-tooth_width / reduction_factor, tooth_length],
            [tooth_width / reduction_factor, tooth_length], [tooth_width / arm_start_width, -tail_length]
          ]);
        }

        // The tip of the arm
        translate([0, tooth_length, 0]) {
          cylinder(r = tooth_width / reduction_factor, h = head_height);
        }
        
/*
        // Arm underside support
        if (tooth_length >= 12) {
          translate([-head_height / 2 + 2, head_diameter / 2 + head_thickness - 0.5, -4]) {
            rotate([90, 0, 0]) {
              rotate([0, -90, 0]) {
                linear_extrude(height = head_height) {
                  polygon([
                    [-tooth_length / 1.7, 4], [0, 4], [0, - reinforcement_height + 5],
                    [-2, - reinforcement_height + 5]
                  ]);
                }
              }
            }
          }
        }
        */
      }

      // Add holes along the shaft
      if(hole_count > 0) {
        for (i = [0 : hole_count - 1]) {
          //translate([0, length - (length / hole_count * i), -1]) {
          translate([0, tooth_length - (4 * i), -1]) {
            cylinder(r = arm_screw_diameter / 2, h = 10);
          }
        }
      }
      cylinder(r = head_screw_diameter / 2, h = 10);
    }
  }
}

module reference_horn() {
  // A "standard" servo horn, for comparison
  translate([8,0,0])
    translate([6.9/2+0.02,-6.9/2-0.02,-4])
      rotate([180,0,90])
        color("red")
          import("SG90_Servo_Horn-1.stl");
}