box_width_in_onions = 2;
box_length_in_onions = 2;
onion_size = 55;
step_between_onions = 5;
root_diameter = 15;
green_diameter = 20;
compressor_diameter = 6;
sphere_sides = 30;

mode = "onion_cup"; // box, box_top, onion_cup

module box() {
    width = box_width_in_onions * (onion_size + step_between_onions) + 5;
    length = box_length_in_onions * (onion_size + step_between_onions) + 5;
    height = onion_size / 2 + 5;

    difference() {
        cube([width, length, height], center=true);

        translate([0, 0, 1.2]) {
            cube([width - 1, length - 1, height], center=true);
        }

        translate([0, width / 2, height / 2 - 5]) {
            rotate([90, 0, 0]) {
                cylinder($fn=20, h=3, d=compressor_diameter, center=true);
            }
        }
    }
};

module box_top() {
    width = box_width_in_onions * (onion_size + step_between_onions) + 7;
    length = box_length_in_onions * (onion_size + step_between_onions) + 7;
    space = onion_size + step_between_onions;
    step = onion_size / 2 + step_between_onions;

    difference() {
        union() {
            cube([width, length, 1.5], center=false);

            for (i = [0 : box_width_in_onions-1]) {
                for (j = [0 : box_length_in_onions-1]) {
                    translate([space * i + step, space * j + step, 0]) {
                        difference() {
                            sphere($fn=sphere_sides, d=onion_size);

                            translate([-onion_size / 2, -onion_size / 2, 0]) {
                                cube(size=onion_size, center=false);
                            }
                        }
                    }
                }
            }
        }

        for (i = [0 : box_width_in_onions-1]) {
            for (j = [0 : box_length_in_onions-1]) {
                onion_cup_hole(space * i + step, space * j + step, -onion_size / 2, root_diameter);
            }
        }
    }
};

module onion_cup() {
    difference() {
        union() {
            translate([0, 0, 0]) {
                difference() {
                    sphere($fn=sphere_sides, d=onion_size);

                    translate([0, 0, -onion_size / 2]) {
                        cube(size=onion_size, center=true);
                    }
                }
            }
        }

        onion_cup_hole(0, 0, onion_size / 2, green_diameter);
    }
};

module onion_cup_hole(x, y, z, diameter) {
    translate([x, y, 0]) {
        sphere($fn=sphere_sides, d=onion_size-2);
    }

    translate([x, y, z]) {
        sphere(d=diameter);
    }
};

if (mode == "box") {
    box();
}
if (mode == "box_top") {
    box_top();
}
if (mode == "onion_cup") {
    onion_cup();
}
