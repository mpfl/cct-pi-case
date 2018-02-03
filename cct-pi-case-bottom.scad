composite_radius = 3;
pi_x = 56;
pi_y = 85;
pi_z = 1.4;
pi_corner_radius = 3;
pi_padding = 0.5;

sd_card_slot_width = 12;

shell_thickness = 0.8;

standoff_height = 2;
standoff_radius = 6.2/2;

smoothness = 36;

standoffs = [[3.5,3.5], [52.5,3.5], [3.5,61.5], [52.5,61.5]];

difference() {
    union() {
        create_shell();
        for ( x = standoffs ) {
            create_standoff(x[0], x[1]);
        }
    }
    create_sd_card_slot();
    # create_composite_port();
    # create_hdmi_port();
    # create_power_port();
    //create_network_port();
    //create_usb_ports();
    create_connectivity_ports();
    for ( x = standoffs ) {
        create_screw_hole(x[0], x[1]);
    }
}
/*translate([pi_x/2,pi_y/2,0])
    rotate(a = 90, v=[0,0,1])
        # import("raspberrypi.stl");*/

module create_shell() {
    translate([pi_corner_radius - shell_thickness - pi_padding, pi_corner_radius - shell_thickness - pi_padding,0-(shell_thickness+standoff_height)])
    difference() {
        minkowski() {
            cube([pi_x - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), pi_y - (2 * pi_corner_radius) + (2 * shell_thickness) + (2 * pi_padding), shell_thickness + standoff_height + pi_z + composite_radius - 1]);
            cylinder(h=1, r = pi_corner_radius, $fn=smoothness);
        }
        translate([shell_thickness, shell_thickness, shell_thickness + pi_corner_radius])
            minkowski() {
                cube([pi_x - (2 * pi_corner_radius) + (2 * pi_padding), pi_y - (2 * pi_corner_radius) + (2 * pi_padding), shell_thickness + standoff_height + pi_z + composite_radius - 1]);
                /* cylinder(h=1, r = pi_corner_radius, $fn=smoothness); */
                sphere(r = pi_corner_radius, $fn = smoothness);
            }
    }
}

module create_connectivity_ports() {
    translate([pi_x - 28.5 - (52.5/2),pi_y + pi_padding - 1, pi_z])
        cube([52.5,shell_thickness + 2, composite_radius + 1]);
}

module create_composite_port() {
    translate([pi_x + pi_padding - 1, 53.5, pi_z + composite_radius])
        rotate(a=90, v=[0,1,0])
            cylinder(h = shell_thickness + 2, r = composite_radius, $fn=smoothness);
}

module create_hdmi_port() {
    translate([pi_x + pi_padding - 1,32-8, pi_z])
        cube([shell_thickness + 2,16, 6.5]);
}

module create_network_port() {
    translate([pi_x + shell_thickness + pi_padding - pi_corner_radius - 10.25 - (17/2),pi_y + shell_thickness + (2 * pi_padding) - pi_corner_radius - 1, shell_thickness + standoff_height + pi_z])
        cube([17,shell_thickness + 2, composite_radius + 1]);
}

module create_power_port() {
    translate([pi_x + pi_padding - 1,10.6 - 5, pi_z])
        cube([shell_thickness + 2,10, composite_radius + 1]);
}

module create_screw_hole(x, y) {
    translate([x, y, 0-(shell_thickness+standoff_height)-0.01])
        union() {
            cylinder(h=shell_thickness + standoff_height + 1, r=2.5/2, $fn=smoothness);
            cylinder(h=1.5, r1=4.7/2, r2=2.5/2, $fn=smoothness);
        }
}

module create_sd_card_slot() {
    translate([pi_x / 2 - sd_card_slot_width / 2, 0-shell_thickness-pi_padding-1, 0-standoff_height])
        cube([sd_card_slot_width,shell_thickness + 5,standoff_height + pi_z + composite_radius + 1]);
}

module create_standoff(x, y) {
    translate([x, y, 0-(shell_thickness+standoff_height)])
        cylinder(h = standoff_height + shell_thickness, r = standoff_radius, $fn = smoothness);
}

module create_usb_ports() {
    translate([pi_x + shell_thickness + pi_padding - pi_corner_radius - 29 - (16/2),pi_y + shell_thickness + (2 * pi_padding) - pi_corner_radius - 1, shell_thickness + standoff_height + pi_z])
        cube([16,shell_thickness + 2, composite_radius + 1]);
    translate([pi_x + shell_thickness + pi_padding - pi_corner_radius - 47 - (16/2),pi_y + shell_thickness + (2 * pi_padding) - pi_corner_radius - 1, shell_thickness + standoff_height + pi_z])
        cube([16,shell_thickness + 2, composite_radius + 1]);   
}