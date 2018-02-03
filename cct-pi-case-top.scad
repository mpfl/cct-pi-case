composite_radius = 3;
pi_x = 56;
pi_y = 85;
pi_z = 10.5;
pi_corner_radius = 3;
pi_padding = 0.5;

network_port_x = 17;
network_port_y = 20;
network_port_z = 13.5;
network_port_location = [pi_x - 10.25, pi_y, 0];

usb_port_x = 14;
usb_port_y = 15.2;
usb_port_z = 16;
usb_port_location = [[pi_x - 29, pi_y, 0], [pi_x - 47, pi_y, 0]];


shell_thickness = 0.8;

case_z = network_port_z - shell_thickness - composite_radius;

sd_card_slot_width = 12;


standoff_radius = 6.2/2;

smoothness = 36;

standoffs = [[3.5,3.5], [52.5,3.5], [3.5,61.5], [52.5,61.5]];
mounting_holes = [[pi_x/2-15,pi_y-60],[pi_x/2+15,pi_y-60],[pi_x/2-15,pi_y-30],[pi_x/2+15,pi_y-30]];
rotate(a = 180, v=[0,1,0])
difference() {
    union() {
        create_shell();
        for ( x = standoffs ) {
           create_standoff(x[0], x[1]);
        }
        create_reinforcement();
        create_sd_card_slot_cover();
    }
    for ( x = standoffs ) {
       create_screw_hole(x[0], x[1]);
    }
    create_power_port();
    create_hdmi_port();
    create_composite_port();
    create_network_port();
    for ( x = usb_port_location ) {
        create_usb_port(x[0], x[1]);
    }
    for ( x = mounting_holes ) {
        create_mounting_hole(x[0], x[1]);
    }
    trim_excess();
}

module create_shell() {
    translate([pi_corner_radius - shell_thickness - pi_padding, pi_corner_radius - shell_thickness - pi_padding, 0])
    difference() {
        minkowski() {
            cube([pi_x - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), pi_y - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), shell_thickness + case_z - 1]);
            cylinder(h=1, r = pi_corner_radius, $fn=smoothness);
        }
        translate([shell_thickness, shell_thickness, 0  - 3])
           minkowski() {
                cube([pi_x - (2 * pi_corner_radius) + (2 * pi_padding), pi_y - (2 * pi_corner_radius) + (2 * pi_padding), shell_thickness +  case_z - 1]);
                sphere( r = pi_corner_radius, $fn = smoothness );
                /* cylinder(h=1, r = pi_corner_radius, $fn=smoothness );*/
            }
    }
}

module create_composite_port() {
    translate([pi_x + pi_padding - 1, 53.5, 0])
        rotate(a=90, v=[0,1,0])
            cylinder(h = shell_thickness + 2, r = composite_radius, $fn=smoothness);
}

module create_connectivity_ports() {
    translate([pi_x - 28.5 - (52.5/2),pi_y + pi_padding - 1, pi_z])
        cube([52.5,shell_thickness + 2, composite_radius + 1]);
}

module create_hdmi_port() {
    translate([pi_x + pi_padding - 1,32-8, 0 - composite_radius])
        cube([shell_thickness + 2,16, 6.5]);
}

module create_mounting_hole(x ,y) {
    translate([x, y, case_z - shell_thickness - 1])
        cylinder( h = shell_thickness * 5, r = 3/2, $fn=smoothness);
}

module create_network_port() {
    translate([network_port_location[0] - (network_port_x/2),network_port_location[1] + pi_padding - network_port_y, 0 - composite_radius])
        cube([network_port_x,network_port_y + 2 * shell_thickness, network_port_z+1]);
}
module create_screw_hole(x, y) {
    translate([x, y, 0 - shell_thickness - composite_radius])
        cylinder(h = case_z + composite_radius, r=2.05/2, $fn=smoothness);
}

module create_sd_card_slot_cover() {
    translate([pi_x / 2 - sd_card_slot_width / 2, 0-shell_thickness-pi_padding, 0-1.4-composite_radius])
       cube([sd_card_slot_width,shell_thickness, pi_z + composite_radius]);
}

module create_power_port() {
    translate([pi_x + pi_padding - 1,10.6 - 5,0 - composite_radius])
        cube([shell_thickness + 2,10, composite_radius + 1]);
}

module create_reinforcement() {
    theta = 0 - atan((case_z)/ network_port_y );
    translate([0 - pi_padding - shell_thickness, pi_y - network_port_y, 0])
        difference() {
            cube([pi_x + pi_padding * 2 + shell_thickness * 2, network_port_y + shell_thickness + pi_padding, case_z]);
            translate([0,0,case_z])
                rotate( a = theta, v = [1,0,0])
                    translate([0,0,0-case_z])
                        cube([pi_x + pi_padding * 2 + shell_thickness * 2, network_port_y * 2, case_z]);
        }
}

module create_standoff(x, y) {
    translate([x, y, 0 - composite_radius])
        cylinder(h = case_z + shell_thickness + composite_radius, r = standoff_radius, $fn = smoothness);
}

module create_usb_port(x, y) {
     translate([x - (usb_port_x/2),y + pi_padding - usb_port_y, 0 - composite_radius])
        cube([usb_port_x,usb_port_y + 2 * shell_thickness, usb_port_z+1]);
}

module trim_excess() {
    translate([pi_corner_radius - shell_thickness - pi_padding, pi_corner_radius - shell_thickness - pi_padding, 0])
        difference() {
            translate([pi_x/-2, pi_y/-2, case_z/-2])
                cube([pi_x*2, pi_y*2, case_z*2]);
                translate([0,0,0-case_z/2])
                    minkowski() {
                        cube([pi_x - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), pi_y - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), 2 * (shell_thickness + case_z - 1)]);
                        cylinder(h=1, r = pi_corner_radius, $fn=smoothness);
                    }
            }
}