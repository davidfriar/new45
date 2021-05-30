
function map(vector, func) =  [ for(x = vector) func(x) ] ;


function bounds(points) = [
   [ min( map(points,function(p) p.x)),min( map(points,function(p) p.y)),min( map(points,function(p) p.z))],
   [ max( map(points,function(p) p.x)),max( map(points,function(p) p.y)),max( map(points,function(p) p.z))]
];


