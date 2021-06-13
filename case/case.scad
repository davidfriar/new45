include <layout.scad>;
include <BOSL/transforms.scad>;
use <keyboard.scad>;
use <functions.scad>;


/*
 * to do :
 * bottom holes in body
 * bottom holes in bottom
 * make bottom just slightly smaller
 * usb cutout
 * name and logo
*/

$fn=60;

test_plane_height = 10;  // [0:0.1:20]
tilt=6.0;
padding = [u(1/8), u(1/8)];
large_radius = u(1/2);
medium_radius = u(3/8);
small_radius = u(1/8);
fillet_radius = u(1/16);
key_clearance = u(1/32);
min_height = 10;
bottom_thickness = 4;
plate_thickness = 1.5;
plate_depth = 7.6;
plate_top = min_height + large_radius - plate_depth;
plate_mount_height = 3;
shock_absorber_height = 1;
shock_absorber_diameter = 4;
shock_absorber_hole_diameter = 2;


plate_hole_diameter = 3.8;
hole_depth = 4.25;
hole_diameter = 3.2;
layout_dimensions = [layout_dimensions(key_layout).x + padding.x * 2, layout_dimensions(key_layout).y+padding.y*2];
base_dimensions = [layout_dimensions.x, layout_dimensions.y * cos(tilt)];
case_dimensions = [ base_dimensions.x + 2*large_radius, base_dimensions.y  + 2 * large_radius * cos(tilt)];

/* body(); */
/* zmove(min_height) ymove(u(1/2)) xmove(u(1/2)) xrot(tilt) #plate(); */

/* echo(layout_dimensions); */
/* plate(); */
/* plate_for_export(); */
/* plate_cutouts(); */

/* xrot(tilt) zmove(min_height)  layout_hole(); */
/* xrot(tilt) zmove(min_height+large_radius)  plate(); */
/* difference(){ */
/*   plate_mounts() shock_absorbers() plate() pcb(); */
/*   plate_mount_holes(); */
/* }; */

body()shock_absorbers() plate() pcb();

/* plate_mounts() shock_absorbers(); */


module body(){
  color("gray") difference(){
    union() {
      difference(){
        body_outside();
        body_inside();
        bottom();
        plate_cutouts();
      }
      zmove(plate_top+shock_absorber_height) xrot(tilt) plate_mounts() ;
    }
    zmove(plate_top+shock_absorber_height) xrot(tilt) plate_mount_holes() ;
    zmove(min_height) xrot(tilt) layout_hole();

  }

  zmove(plate_top+shock_absorber_height) xrot(tilt) children();
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
  ymove(u(1+1/8)-key_clearance) xmove(u(13-5/8)+key_clearance) fillet(fillet_radius, u(1), 270);
  ymove(u(1+1/8)-key_clearance) xmove(u(7/8)-key_clearance) fillet(fillet_radius, u(1), 180);
}

module fillet(r, h, rot=0){
  rotate([0,0,180+rot])translate([0.001-r, 0.001-r, -0.001])
    difference(){
      cube([r+0.002,r+0.002,h+0.002]);
      translate([0,0,-0.001]) cylinder(r=r, h=h+0.008);
    }

}


module plate_cutouts(){
  layout_plate_tabs_row() plate_cutout(-u(1/8));
  layout_plate_tabs_row() plate_cutout(base_dimensions.y + u(1/8));
}

module plate_cutout(y){
  hull(){
    ymove(y) cylinder(d=u(1/2), h=0.01);
    zmove(plate_top+shock_absorber_height) xrot(tilt) ymove(y/cos(tilt)) cylinder(d=u(1/2), h=0.01);
  }
}

module plate_mounts(){
  layout_plate_tabs(){
    cylinder(d=u(1/2), h=plate_mount_height);
  }
  children();
}

module plate_mount_holes(){
  zmove(-0.001) {
    layout_plate_tabs(){
      cylinder(d=hole_diameter, h=hole_depth);
    }
  }
}

module shock_absorbers(){
  zmove(-shock_absorber_height) {
    layout_plate_tabs(){
      difference(){
        cylinder(d=shock_absorber_diameter, h=shock_absorber_height);
        zmove(-0.01) cylinder(d=shock_absorber_hole_diameter, h=shock_absorber_height+0.02);

      }
    }
    children();
  }
}

module plate_for_export(){
  ymove(u(1/8)+4) projection() plate();
}

module plate(){
  zmove(-plate_thickness) linear_extrude(plate_thickness) {
    difference(){
      union(){
        xmove(-0.1) ymove(-0.43) import("swillkb.dxf");
        layout_plate_tabs() plate_tab();
      }
      layout_plate_tabs() plate_tab_hole();
    }
  }
  zmove(-5) children();
}

module layout_plate_tabs(){
  yflip_copy(cp=[0,u(2+1/8),0]){
    ymove(-u(1/8)) layout_plate_tabs_row() children();
  }
}

module layout_plate_tabs_row() {
  xspread(sp=[u(5/8),0,0], n=5, spacing=u(12/4)) children();
}

module plate_tab(){
  circle(d=8);
  ymove(2) square([8,4], center=true);
}

module plate_tab_hole(){
  circle(d=plate_hole_diameter);
}

module pcb() {
  translate([-26.25, 103.9425, -1.6 ]) import("../pcb/new45.stl");
}


module test_plane(){
    zmove(test_plane_height) xrot(tilt) color("red") cube([100, 100, 0.1]);
}

/* for(key=key_layout){ */
/*   translate([key_x(key), key_y(key), 0]) square([key_w(key), key_h(key)]); */
/* } */


/* color("red") keyboard_bounding_box(key_layout); */
