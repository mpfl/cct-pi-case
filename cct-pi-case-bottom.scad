composite_radius = 3;
pi_x = 56;
pi_y = 85;
pi_z = 1.4;
pi_corner_radius = 3;
pi_padding = 0.5;

sd_card_slot_width = 12;

shell_thickness = 1.2;

standoff_height = 2;
standoff_radius = 6.2/2;
standoffs = [[3.5,3.5], [52.5,3.5], [3.5,61.5], [52.5,61.5]];

network_port_x = 17;
network_port_y = 20;
network_port_z = 14;
network_port_location = [pi_x - 10.25, pi_y, 0];

usb_port_x = 14;
usb_port_y = 15.2;
usb_port_z = 16.5;
usb_port_location = [[pi_x - 29, pi_y, 0], [pi_x - 47, pi_y, 0]];

smoothness = 36;

translate([shell_thickness + pi_padding, shell_thickness + pi_padding, shell_thickness + standoff_height])
    difference() {
        union() {
            create_shell();
            for ( x = standoffs ) {
                create_standoff(x[0], x[1]);
            }
        }
        create_sd_card_slot();
        create_composite_port();
        create_hdmi_port();
        create_power_port();
        create_network_port();
        for ( x = usb_port_location ) {
            create_usb_port(x[0], x[1]);
        }
        for ( x = standoffs ) {
            create_screw_hole(x[0], x[1]);
        }
    }

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
    translate([network_port_location[0] - (network_port_x/2),network_port_location[1] + pi_padding - network_port_y,  pi_z])
        cube([network_port_x,network_port_y + 2 * shell_thickness, network_port_z+1]);
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

module create_usb_port(x, y) {
     translate([x - (usb_port_x/2),y + pi_padding - usb_port_y, pi_z])
        cube([usb_port_x,usb_port_y + 2 * shell_thickness, usb_port_z+1]);
}