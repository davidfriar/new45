include <layout.scad>;
include <BOSL/transforms.scad>;
use <keyboard.scad>;
use <functions.scad>;


$fn=60;

tilt=6.0;
layout_dimensions = layout_dimensions(key_layout);
large_radius = u(1/2);
medium_radius = u(1/4);
small_radius = u(1/8);
min_height = 10;
case_dimensions = [ layout_dimensions.x + 2*large_radius, (layout_dimensions.y + 2 * large_radius) * cos(tilt)];
bottom_thickness = 4;
plate_thickness = 1.5;

body();
zmove(min_height) ymove(u(1/2)) xmove(u(1/2)) xrot(tilt) #plate();

module body(){
  difference(){
    body_outside();
    body_inside();
    translate([0,0,-0.001]) bottom();
    translate([0,0,min_height+0.001]) rotate([tilt, 0,0]) translate([large_radius, large_radius, 0]) layout_hole();

  }
}

module body_outside() {
  translate([0,0,small_radius]) hull(){
    translate([0,0,min_height-small_radius]) xrot(tilt){
      translate([large_radius, large_radius, 0]) sphere(r=large_radius);
      translate([large_radius+layout_dimensions.x, large_radius, 0]) sphere(r=large_radius);
      translate([large_radius, large_radius+layout_dimensions.y, 0]) sphere(r=large_radius);
      translate([large_radius+layout_dimensions.x, large_radius+layout_dimensions.y, 0]) sphere(r=large_radius);
    }
    translate([large_radius, large_radius, 0]) cylinder(r=large_radius, h=1);
    translate([case_dimensions.x-large_radius, large_radius, 0]) cylinder(r=large_radius, h=1);
    translate([large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=large_radius, h=1);
    translate([case_dimensions.x-large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=large_radius, h=1);
    corner();
    translate([case_dimensions.x, 0,0]) rotate([0,0,90]) corner();
    translate([0,case_dimensions.y,0]) rotate([0,0,-90]) corner();
    translate([case_dimensions.x,case_dimensions.y,0]) rotate([0,0,180]) corner();
  }
}

module body_inside(){
  translate([0,0,-0.001]) hull(){
    translate([0,0,min_height+u(1/8)+0.001]) xrot(tilt) {
      translate([large_radius, large_radius, 0]) sphere(r=small_radius);
      translate([large_radius+layout_dimensions.x, large_radius, 0]) sphere(r=small_radius);
      translate([large_radius, large_radius+layout_dimensions.y, 0]) sphere(r=small_radius);
      translate([large_radius+layout_dimensions.x, large_radius+layout_dimensions.y, 0]) sphere(r=small_radius);
    }
    translate([large_radius, large_radius, 0]) cylinder(r=small_radius, h=1);
    translate([case_dimensions.x-large_radius, large_radius, 0]) cylinder(r=small_radius, h=1);
    translate([large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=small_radius, h=1);
    translate([case_dimensions.x-large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=small_radius, h=1);
  }
}


module corner(){
  translate([large_radius,large_radius,-(large_radius-small_radius)]) rotate([0,0,180]) rotate_extrude(angle=90) translate([large_radius-small_radius, large_radius-small_radius]) circle(r=small_radius);
}

module bottom(){
  hull(){
    translate([large_radius, large_radius, 0]) cylinder(r=medium_radius, h=bottom_thickness);
    translate([case_dimensions.x-large_radius, large_radius, 0]) cylinder(r=medium_radius, h=bottom_thickness);
    translate([large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=medium_radius, h=bottom_thickness);
    translate([case_dimensions.x-large_radius, case_dimensions.y-large_radius, 0]) cylinder(r=medium_radius, h=bottom_thickness);
  }
}

module layout_hole(){
  difference(){
    union(){
      for(key=key_layout){
        translate([key_x(key)-0.001, u(3) - key_y(key) + 0.001, 0]) cube([key_w(key)+0.002, key_h(key)+0.002, large_radius]);
      }
    }
    xmove(u(3/4)) fillet(small_radius, large_radius);
    ymove(u(1)) fillet(small_radius, large_radius);
    ymove(u(4)) fillet(small_radius, large_radius, 270);
    xmove(u(13 - 3/4)) fillet(small_radius, large_radius, 90);
    ymove(u(1)) xmove(u(13)) fillet(small_radius, large_radius, 90);
    ymove(u(4)) xmove(u(13)) fillet(small_radius, large_radius, 180);
  }
  ymove(u(1)) xmove(u(13-3/4)) fillet(small_radius, large_radius, 270);
  ymove(u(1)) xmove(u(3/4)) fillet(small_radius, large_radius, 180);
}

module fillet(r, h, rot=0){
  rotate([0,0,180+rot])translate([0.001-r, 0.001-r, -0.001])
  difference(){
    cube([r+0.002,r+0.002,h+0.002]);
    translate([0,0,-0.001]) cylinder(r=r, h=h+0.008);
  }

}

module plate(){
  linear_extrude(plate_thickness) {
    difference(){
      union(){
        import("swillkb.dxf");
        ymove(u(4)){
          xmove(u(1)) plate_tab();
          xmove(u(4)) plate_tab();
          xmove(u(9)) plate_tab();
          xmove(u(12)) plate_tab();
        }
      }
      ymove(u(4)){
          xmove(u(1)) circle(d=4);
          xmove(u(4)) circle(d=4);
          xmove(u(9)) circle(d=4);
          xmove(u(12)) circle(d=4);
      }
      ymove(u(1/4)){
          xmove(u(1/2)) circle(d=4);
          xmove(u(4+1/8)) circle(d=4);
          xmove(u(8+7/8)) circle(d=4);
          xmove(u(12+1/2)) circle(d=4);
      }
    }
  }
}

module plate_tab(){
  top_half(planar=true) circle(d=8);
}



/* for(key=key_layout){ */
/*   translate([key_x(key), key_y(key), 0]) square([key_w(key), key_h(key)]); */
/* } */


/* color("red") keyboard_bounding_box(key_layout); */
