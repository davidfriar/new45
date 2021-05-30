include <functions.scad>;





function u(x) = x * 25.4 * 0.75;

function key_x(key) = u(key[0]);
function key_y(key) = u(key[1]);
function key_w(key) = u(key[2]);
function key_h(key) = u(key[3]);

key_bottom_left = function (key) [key_x(key), key_y(key), 0];
key_top_right = function (key) [key_x(key)+key_w(key), key_y(key)+key_h(key), 0];


function layout_bounds(keys) = bounds(concat(map(keys, key_bottom_left), map(keys, key_top_right)));

function dimensions(bounds) = [ bounds[1].x - bounds[0].x, bounds[1].y - bounds[0].y];

function layout_dimensions(keys) = dimensions(layout_bounds(keys));

module layout_bounding_box(keys){
   bounds=layout_bounds(keys);
   translate([bounds[0].x, bounds[0].y, 0]) square(dimensions(bounds));
}
