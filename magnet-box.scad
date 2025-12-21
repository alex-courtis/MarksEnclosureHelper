include <hingebox_code.scad> // uses github.com/h2odragon/MarksEnclosureHelper

// yellow box 160x235x48

// 4 boxes
// total width: 235/4 = 58.75
// subtract dovetail width 4: 54.75
// subtract hanging dovetail 4/4: 53.75
// subtract some wiggle room 0.5: 53.25
x_outer = 53.25; // [1:0.05:500]

// 2 boxes
// total width: 160 / 2 = 80
// subtract dovetail width 4: 76
// subtract hinge ~ 5: 71
// leaves ~2 wiggle
y_outer = 71; // [1:0.1:500]

// add two wall_thick 26 + 2 * 1.2
z_outer = 28.4; // [1:0.1:500] 

bd = [x_outer, y_outer, z_outer];

x_inner = 26; // [1:0.5:100]
y_inner = 48; // [1:0.5:100]
z_inner = 12.5; // [1:0.5:100]

// top and bottom of inner
z_padding = 0; // [0:0.5:100]

wall_thick = 1.2; // [0.2:0.2:8]
top_rat = 0.15;
lip_rat = 0.05;
corner_radius = 6;

hinge_points = [0.5];
hinge_len = 30;

// M3 hex option
// hinge_zrat = 0.845;
// hinge_id = 3 / sqrt(3) * 2;
// echo(hinge_id=hinge_id);
// hinge_od = 3 / sqrt(3) * 2 * 1.75;
// echo(hinge_od=hinge_od);
// hinge_ifn = 6;

// M3 circle tweaked to keep upper hinge on baseplate and lower inside dovetail
hinge_zrat = 0.9085;
hinge_id = 3.185;
echo(hinge_id=hinge_id);
hinge_od = 5.2;
echo(hinge_od=hinge_od);
hinge_ifn = 200;
hinge_basepoint_bottom = 0;
hinge_basepoint_top = 0;
hinge_midpoint = 0;

catch_points = [0.5];
catch_thick = 2;
catch_tooth_zrat = 0.8;
catch_wide = 0.4;
catch_wide_bottom = 0.7;

VIS = false;

// length of dovetail shape
dtlen = 10;
// clearance for the dovetail notch
dt_CLEAR = 0.75;
// dovetail profile: height, top width, bottom width, taper, taper_point
dtspec = [4, 16, 6, 3, dtlen * 0.85];
// extra thickness around block 
bthick = 6;
// block that recives dovetail 
dtblock = [dtlen, dtspec[1] + (bthick * 2) + (dt_CLEAR), (dtspec[0])];

module insert_bottom(d) {
  diecut(d) {

    x1 = (d.x - x_inner - wall_thick) / 2 / d.x;
    x2 = 1 - x1;
    xdiv = [x1, x2];
    echo(xdiv=xdiv);

    y1 = (d.y - y_inner - wall_thick) / 2 / d.y;
    y2 = 1 - y1;
    ydiv = [y1, y2];
    echo(ydiv=ydiv);

    h = z_inner;
    echo(h=h);

    dividers(d=d, xdiv=xdiv, ydiv=ydiv, h=h, t=wall_thick);
  }
}

module decorate_left(d) { mydttng(bd.y); }
module decorate_right(d) { mydtnotch(bd.y); }

module decorate_top(d) {
  mypadding(
    d,
    dx=-wall_thick,
    dy=-wall_thick
  );
}
module decorate_bottom(d) {
  mypadding(
    d,
    dx=wall_thick,
    dy=wall_thick
  );
}

module mypadding(d, dx, dy) {
  translate(
    v=[
      dx + (d.x + wall_thick) / 2,
      dy + (d.y + wall_thick) / 2,
      z_padding / 2,
    ]
  )
    cube(
      size=[
        x_inner,
        y_inner,
        z_padding,
      ], center=true
    );
}

module mydttng(l) {
  cp = (l / 2) - (dtspec[1] / 2);
  translate([cp, 0, 0])
    //translate( [dtspec[1],0,0]) rotate([0,0,90])  // taper up
    translate([0, dtlen, 0]) rotate([0, 0, 270]) // taper down
        dovetail_rail(dtlen, dtspec);
}

module mydtnotch(l) {
  cp = (l / 2) - (dtblock[1] / 2);
  translate([cp, 0, 0])
    translate([dtblock[1], 0, 0]) rotate([0, 0, 90])
        dovetail_block(dtblock, dtspec, dt_CLEAR);
}

render()
  hingedbox(bd);
