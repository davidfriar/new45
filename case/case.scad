include <layout.scad>;
include <BOSL/transforms.scad>;
use <keyboard.scad>;
use <functions.scad>;


$fn=60;

tilt=6.0;
padding = [u(1/8), u(1/8)];
layout_dimensions = [layout_dimensions(key_layout).x + padding.x * 2, layout_dimensions(key_layout).y+padding.y*2];
large_radius = u(1/2);
medium_radius = u(1/4);
small_radius = u(1/8);
fillet_radius = u(1/16);
key_clearance = u(1/32);
min_height = 10;
base_dimensions = [layout_dimensions.x, layout_dimensions.y * cos(tilt)];
case_dimensions = [ base_dimensions.x + 2*large_radius, base_dimensions.y  + 2 * large_radius * cos(tilt)];
bottom_thickness = 4;
plate_thickness = 1.5;

body();
zmove(min_height) ymove(u(1/2)) xmove(u(1/2)) xrot(tilt) #plate();

module body(){
  xmove(large_radius) ymove(large_radius) difference(){
    body_outside();
    body_inside();
    bottom();
    zmove(min_height) rotate([tilt, 0,0])  layout_hole();
  }
}

module body_outside() {
  zmove(small_radius) hull(){
    zmove(min_height-small_radius) xrot(tilt){
      sphere(r=large_radius);
      xmove(layout_dimensions.x) sphere(r=large_radius);
      ymove(layout_dimensions.y) sphere(r=large_radius);
      xmove(layout_dimensions.x) ymove(layout_dimensions.y) sphere(r=large_radius);
    }
    cylinder(r=large_radius, h=1);
    xmove(base_dimensions.x) cylinder(r=large_radius, h=1);
    ymove( base_dimensions.y) cylinder(r=large_radius, h=1);
    xmove(base_dimensions.x) ymove( base_dimensions.y) cylinder(r=large_radius, h=1);
    corner();
    xmove(base_dimensions.x) rotate([0,0,90]) corner();
    ymove(base_dimensions.y) rotate([0,0,-90]) corner();
    xmove(base_dimensions.x) ymove(base_dimensions.y) rotate([0,0,180]) corner();
  }
}

module body_inside(){
  zmove(-0.01) hull(){
    zmove(min_height+u(1/8)+0.001) xrot(tilt) {
      sphere(r=small_radius);
      xmove(layout_dimensions.x) sphere(r=small_radius);
      ymove(layout_dimensions.y) sphere(r=small_radius);
      xmove(layout_dimensions.x) ymove(layout_dimensions.y) sphere(r=small_radius);
    }
    cylinder(r=small_radius, h=1);
    xmove(base_dimensions.x) cylinder(r=small_radius, h=1);
    ymove(base_dimensions.y) cylinder(r=small_radius, h=1);
    xmove(base_dimensions.x) ymove(base_dimensions.y) cylinder(r=small_radius, h=1);
  }
}


module corner(){
  zmove(-(large_radius-small_radius)) rotate([0,0,180]) rotate_extrude(angle=90) translate([large_radius-small_radius, large_radius-small_radius]) circle(r=small_radius);
}

module bottom(){
  zmove(-0.01) hull(){
    cylinder(r=medium_radius, h=bottom_thickness);
    translate([base_dimensions.x, 0, 0]) cylinder(r=medium_radius, h=bottom_thickness);
    translate([0, base_dimensions.y, 0]) cylinder(r=medium_radius, h=bottom_thickness);
    translate([base_dimensions.x, base_dimensions.y, 0]) cylinder(r=medium_radius, h=bottom_thickness);
  }
}

module layout_hole(){
  zmove(-u(1/4)) xmove(padding.x) ymove(padding.y)
  difference(){
    union(){
      for(key=key_layout){
        translate([key_x(key)-key_clearance, u(3) - key_y(key)-key_clearance, 0]) cube([key_w(key)+2*key_clearance, key_h(key)+2*key_clearance, u(1)]);
      }
    }
    xmove(u(3/4)-key_clearance) ymove(-key_clearance) fillet(fillet_radius, u(1));
    xmove(-key_clearance) ymove(u(1)-key_clearance) fillet(fillet_radius, u(1));
    xmove(-key_clearance) ymove(u(4)+key_clearance) fillet(fillet_radius, u(1), 270);
    xmove(u(13 - 3/4)+key_clearance) ymove(-key_clearance) fillet(fillet_radius, u(1), 90);
    ymove(u(1)-key_clearance) xmove(u(13)+key_clearance) fillet(fillet_radius, u(1), 90);
    ymove(u(4)+key_clearance) xmove(u(13)+key_clearance) fillet(fillet_radius, u(1), 180);
  }
  ymove(u(1)-key_clearance) xmove(u(13-3/4)+key_clearance) fillet(fillet_radius, u(1), 270);
  ymove(u(1)-key_clearance) xmove(u(3/4)-key_clearance) fillet(fillet_radius, u(1), 180);
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
