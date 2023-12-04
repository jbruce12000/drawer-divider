/* [Overall] */

// show divider
show_divider="yes"; //[yes,no]
length=1300;
height=100;
wall=3;
gap_spacing=20.0; //[1:.1:50]
chamfer=wall/2;

// show_clip
show_clip="yes"; //[yes,no]

/* [Other Options] */
$fn=4;
safety=.01;
gap_w=wall+.1;
// .3 here so the gap goes just a little past center to keep crossed pieces
// from rocking
gap_h=(height/2)+.3;

//----------------------------------------------------------------------------
module divider_base(h=50,l=130) {
cube([l,h,wall],center=true);
}

//----------------------------------------------------------------------------
module cut_gaps(spacing=20) {
difference() {
children();
union() {
gaps();
}
}
}

//----------------------------------------------------------------------------
module gaps() {

translate([(length/2)-gap_spacing+wall/2,gap_h/2-.1,0])
gap();

for(i=[-length/2+gap_spacing-(wall/2):gap_spacing:length/2-gap_spacing*2]) {
translate([i,gap_h/2-.1,0])
gap();
}
}

//----------------------------------------------------------------------------
module gap() {

union() {
cube([gap_w,gap_h,gap_w],center=true);

mirror([1,0,0])
translate([0,gap_h/2-gap_w/2,0])
translate([-gap_w+safety,0,0])
small_triangle(size=gap_w/2,thickness=gap_w);

translate([0,gap_h/2-gap_w/2,0])
translate([-gap_w+safety,0,0])
small_triangle(size=gap_w/2,thickness=gap_w);
}
}

//----------------------------------------------------------------------------
module cut_corners(chamfer=1) {
c=chamfer;
difference() {
children();
union() {
mirror([0,1,0])
mirror([1,0,0])
translate([length/2-c+safety,height/2-c+safety,0])
small_triangle(size=c,thickness=wall*2);

mirror([1,0,0])
translate([length/2-c+safety,height/2-c+safety,0])
small_triangle(size=c,thickness=wall*2);

mirror([0,1,0])
translate([length/2-c+safety,height/2-c+safety,0])
small_triangle(size=c,thickness=wall*2);

translate([length/2-c+safety,height/2-c+safety,0])
small_triangle(size=c,thickness=wall*2);
}
}
}

//----------------------------------------------------------------------------
module small_triangle(size=5,thickness=3) {
c=size;
linear_extrude(height=thickness+safety,center=true)
polygon([[c+safety,0],[c+safety,c+safety],[0,c+safety],[c+safety,0]]);
}
//----------------------------------------------------------------------------
module clip(gap_spacing=15,height=100) {
comb_w=gap_spacing-wall;
translate([0,0,height/8])
rotate([90,0,0])
difference() {
cube([comb_w*2+wall*2,height/4,wall*3],center=true);
//.2 here so the fit is not too tight
cube([comb_w*2+.2,height,wall],center=true);
}
}

if(show_clip=="yes") {
  clip(height=height,gap_spacing=gap_spacing);
  }
if(show_divider=="yes") {
  translate([0,0,wall/2])
  cut_corners(chamfer=chamfer)
  cut_gaps()
  divider_base(h=height,l=length);
  }
