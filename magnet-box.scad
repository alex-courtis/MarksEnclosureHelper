include <hingebox_code.scad> // uses github.com/h2odragon/MarksEnclosureHelper

x_outer = 56;  // [1:1:500]
y_outer = 73;  // [1:1:500]

// add two wall_thick 26 + 2 * 1.2
z_outer = 28.4;  // [1:1:500] 

bd = [x_outer, y_outer, z_outer];

x_inner = 26; // [1:1:100]
y_inner = 43; // [1:1:100]
z_inner = 12.5; // [1:1:100]

wall_thick = 1.2; // [0.2:0.2:8]
top_rat = 0.15;
lip_rat = 0.05;
corner_radius = 6;

hinge_points = [0.5];
hinge_len = 43;
hinge_od = 6.4;
hinge_id = 3.8;  

catch_points = [0.5];
catch_thick = 2;
catch_tooth_zrat = 0.8;
catch_wide = 0.4;
catch_wide_bottom = 0.7;

VIS = false;

// length of dovetail shape
dtlen = 16;
// clearance for the dovetail notch
dt_CLEAR = 1.5;
// dovetail profile: height, top width, bottom width, taper, taper_point
dtspec = [4, 14, 6, 3, dtlen * 0.85];
// extra thickness around block 
bthick = 6;
// block that recives dovetail 
dtblock = [dtlen, dtspec[1] + (bthick * 2) + (dt_CLEAR), (dtspec[0])];

module insert_bottom(d) {
  diecut(d) {
    echo(d=d);

    x1 = (d.x - x_inner - wall_thick) / 2 / d.x;
    echo(x1=x1);
    x2 = 1 - x1;
    echo(x2=x2);
    xdiv = [x1, x2];
    echo(xdiv=xdiv);

    y1 = (d.y - y_inner - wall_thick) / 2 / d.y;
    echo(y1=y1);
    y2 = 1 - y1;
    echo(y2=y2);
    ydiv = [y1, y2];
    echo(ydiv=ydiv);

	h = z_inner;

    dividers(d=d, xdiv=xdiv, ydiv=ydiv, h=h, t=wall_thick);
  }
}

module decorate_left(d) { mydttng(d); }
module decorate_right(d) { mydtnotch(d); }

module mydttng(d) {
  cp = (bd.y / 2) - (dtspec[1] / 2);
  translate([cp, 0, 0])
    //translate( [dtspec[1],0,0]) rotate([0,0,90])  // taper up
    translate([0, dtlen, 0]) rotate([0, 0, 270]) // taper down
        dovetail_rail(dtlen, dtspec);
}

module mydtnotch(d) {
  cp = (bd.y / 2) - (dtblock[1] / 2);
  translate([cp, 0, 0])
    translate([dtblock[1], 0, 0]) rotate([0, 0, 90])
        dovetail_block(dtblock, dtspec, dt_CLEAR);
}

render()
  hingedbox(bd);

