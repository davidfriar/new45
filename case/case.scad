include <layout.scad>;
include <daughterboard.scad>;
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

test_plane_height = 10;  // [0:0.1:30]
tilt=7.0;
padding = [u(1/8), u(1/8)];
large_radius = u(1/2);
medium_radius = u(3/8);
small_radius = u(1/8);
fillet_radius = u(1/16);
key_clearance = u(1/32);
min_height = 12;
bottom_thickness = 4;
plate_thickness = 1.5;
plate_depth = 7;
plate_top = min_height + large_radius - plate_depth;
plate_mount_height = 2;
shock_absorber_height = 1;
shock_absorber_diameter = 4;
shock_absorber_hole_diameter = 2;


plate_hole_diameter = 3.8;
hole_depth = 4.25;
hole_diameter = 3.2;
layout_dimensions = [layout_dimensions(key_layout).x + padding.x * 2, layout_dimensions(key_layout).y+padding.y*2];
base_dimensions = [layout_dimensions.x, layout_dimensions.y * cos(tilt)];
case_dimensions = [ base_dimensions.x + 2*large_radius, base_dimensions.y  + 2 * large_radius * cos(tilt)];

bottom_hole_diameter = 2.4;
bottom_hole_height = bottom_thickness + 1;
bottom_hole_countersink_diameter = 4;
bottom_hole_countersink_height = 2;

daughterboard_hole_depth = 2.5;
daughterboard_mount_height = 2;
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

/* body()shock_absorbers() plate() pcb(); */
/* zmove(bottom_thickness) ymove(u(2))xmove(u(5.5)) daughterboard(); */

/* bottom() daughterboard(); */
/* daughterboard_hole(); */
/* test_plane(); */
/* nice_nano(); */
/* daughterboard(); */

/* plate_mounts() shock_absorbers(); */

/* body()shock_absorbers() plate(); */
/* bottom(); */

/* bottom()daughterboard(); */
body() shock_absorbers() plate();
bottom() daughterboard();
/* button_cutout(); */

/* usb_cutout(); */

module body(){
  color("gray") difference(){
    union() {
      difference(){
        body_outside();
        body_inside();
        bottom(clearance=0.25, holes=false);
        plate_cutouts();
        insert_holes();
        ymove(u(2))xmove(u(5.5)) daughterboard_cutout();
        usb_cutout();
        button_cutout();


      }
      insert_mounts();
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

module bottom(clearance=0, holes=true){
  zmove(-0.01) difference() {
    hull(){
      cylinder(r=medium_radius+clearance, h=bottom_thickness);
      translate([base_dimensions.x, 0, 0]) cylinder(r=medium_radius+clearance, h=bottom_thickness);
      translate([0, base_dimensions.y, 0]) cylinder(r=medium_radius+clearance, h=bottom_thickness);
      translate([base_dimensions.x, base_dimensions.y, 0]) cylinder(r=medium_radius+clearance, h=bottom_thickness);
    }
    if(holes) {
      zmove(-0.5) layout_bottom_holes() bottom_hole();
      zmove(bottom_thickness-(daughterboard_hole_depth)) ymove(u(2))xmove(u(5.5)) daughterboard_hole();
    }
  }
  if(holes){
    zmove(bottom_thickness - daughterboard_hole_depth ) ymove(u(2))xmove(u(5.5)) daughterboard_mounts();
    zmove(bottom_thickness - daughterboard_hole_depth + daughterboard_mount_height) ymove(u(2))xmove(u(5.5)) children();
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
  translate([-26.25, 103.9425, -1.6 ])  import("../pcb/new45.stl");
}




module test_plane(){
    zmove(test_plane_height) xrot(tilt) color("red") cube([100, 100, 0.1]);
}

module layout_bottom_holes(){
  adjust = 0.5;
  yspread(sp=[0,u(-1/4)+adjust,0], n=2, spacing=base_dimensions.y+u(1/2)-2*adjust)
    xspread(sp=[u(2+1/8),0,0], n=4, spacing=u(3)) children();
  ymove(base_dimensions.y/2) {
    xmove(adjust) xmove(-u(1/4)) children();
    xmove(-adjust) xmove(base_dimensions.x+u(1/4))children();
  }
}

module bottom_hole() {
  cylinder(d=bottom_hole_diameter, h=bottom_hole_height);
  cylinder(d=bottom_hole_countersink_diameter, h=bottom_hole_countersink_height);
}

module insert_holes() {
   zmove(bottom_thickness-0.1) layout_bottom_holes() insert_hole();
}

module insert_hole() {
  cylinder(d=hole_diameter, hole_depth);
}

module insert_mounts(){
  zmove(bottom_thickness) layout_bottom_holes() insert_mount();
}

module insert_mount() {
  difference(){
  cylinder(d=hole_diameter+3, hole_depth + 2);
  zmove(-0.1) insert_hole();
  }
}

module daughterboard_cutout(){
   daughterboard_hole(height=15);
}

module daughterboard_hole(height=4) {
   radius=u(1/8);
   clearance=0.5;
   hull()
     yspread(sp=[0, radius, 0], n=2, spacing=u(2.25))
       xspread(sp=[radius, 0, 0],n=2, spacing=u(2))
         cylinder(r=radius+clearance, h=height);

}

module daughterboard_mounts(){
   xmove(u(1/4)) ymove(u(1/4)) daughterboard_mount();
   xmove(u(2)) ymove(u(1/4)) daughterboard_mount();
   xmove(u(1/4)) ymove(u(2+1/4)) daughterboard_mount();
   xmove(u(2)) ymove(u(1+3/4)) daughterboard_mount();
}

module daughterboard_mount(){
   difference(){
     cylinder(d=u(11/16), h=daughterboard_mount_height);
     zmove(-1) cylinder(d=2.4, h=daughterboard_mount_height+2);
     zmove(0.25) cylinder(d=4.5, h=2, $fn=6);
   }
}


module usb_cutout(){
  zmove(bottom_thickness + 2.8) xmove(base_dimensions.x/2) ymove(base_dimensions.y + 9) zrot(-90) translate([0, -usb_sheath_width/2, -usb_sheath_height/2]) zrot(90)xrot(90) {
    translate([usb_sheath_offset, usb_sheath_offset, 0]) rounded_rect([usb_plug_width, usb_plug_height, usb_plug_length],radius=1);
    translate([0,0, -usb_sheath_length]) rounded_rect([usb_sheath_width, usb_sheath_height, usb_sheath_length],radius=3);
  }
}


module button_cutout() {
  zmove(8.65) xmove(base_dimensions.x/2+14.95) ymove(base_dimensions.y+7) xrot(90) zmove(-5) cylinder(d=3.5, h=10);
}
