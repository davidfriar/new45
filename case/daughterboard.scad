nano_length=33.3;
nano_width=18.1;
nano_thickness=1.5;
nano_clearance=1;
usb_socket_length=8.9;
usb_plug_width=8.9;
usb_plug_height=3.2;
usb_plug_length=8.54;
usb_sheath_offset=2;
usb_sheath_width=usb_plug_width+2*usb_sheath_offset;
usb_sheath_height=usb_plug_height+2*usb_sheath_offset;
usb_sheath_length=30;
socket_height=4.95;


module daughterboard(){
 xmove(u(2.25)) ymove(u(2.5)) zrot(270) translate([-46.83125,38.89375,0 ]) import("../daughterboard/daughterboard.stl");
 /* translate([13.81125, 15.39875, 1.6]) socket(); */
 /* translate([29.05125, 15.39875, 1.6]) socket(); */
 ymove(15.39875+nano_length-1.27) xmove(u(1.125)) xmove(-nano_width/2) zmove(nano_thickness+1.6+1.8) zrot(-90) ymove(nano_width)xrot(180) nice_nano();

}


module nice_nano() {
  nano_socket_border = (nano_width - 2.54*7) / 2 ;
  color("dimgray") rounded_rect([nano_length, nano_width, nano_thickness], radius=1.5);
  translate([ 0, (nano_width - usb_socket_length)/2 , 0 ]) rotate([90,0,90]) usb_socket();
  /* for(i=[0:1]){ */
  /*   translate([2.82,nano_socket_border+i*6*2.54,nano_thickness]) socket(); */
  /* } */
}


module rounded_rect(size, radius=5){
  hull(){
    translate([radius, radius]) cylinder(h=size.z, r=radius);
    translate([size.x-radius, radius]) cylinder(h=size.z, r=radius);
    translate([radius, size.y-radius]) cylinder(h=size.z, r=radius);
    translate([size.x-radius, size.y-radius]) cylinder(h=size.z, r=radius);
  }
}


module usb_socket(){
  color("silver") rounded_rect([8.9, 3.2, 6.5],radius=1);
}


module socket() {
  zrot(90) translate([-1.27, -1.27]) difference(){
    color("black") cube([30.48, 2.54, socket_height]);
    for(i=[0:11]){
      translate([1.27+i*2.54, 1.27, -1 ]) cylinder(d=1.092,h=10);
    }
  }
}
