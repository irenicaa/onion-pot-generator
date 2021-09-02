width_onion = 2;
length_onion = 2;
onion_size = 55;
step_between_onions = 5;
root_diameter = 15;
green_diameter = 20;
sphere_sides = 30;
height = onion_size / 2 + 5;
compressor_diameter = 6;

mode = "onion_cup"; // box, box_top, onion_cup

module box(width_onion, onion_size, step_between_onions) {
    width = width_onion * (onion_size + step_between_onions) + 5;
    length = length_onion * (onion_size + step_between_onions) + 5;

    difference() {
        cube([width, length, height], center=true);

        translate([0, 0, 2]) {
            cube([width - 0.8, length - 0.8, height], center=true);
        }

        translate([0, width / 2, height / 2 - 5]) {
            rotate([90, 0, 0]) {
                cylinder($fn=20, h=3, d=compressor_diameter, center=true);
            }
        }
    }
};

module box_top(width_onion, onion_size, step_between_onions) {
    width = width_onion * (onion_size + step_between_onions) + 7;
    length = length_onion * (onion_size + step_between_onions) + 7;
    space = onion_size + step_between_onions;
    step = onion_size / 2 + step_between_onions;

    difference() {
        union() {
            cube([width, length, 1.5], center=false);

            for (i = [0 : width_onion-1]) {
                for (j = [0 : length_onion-1]) {
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

        for (i = [0 : width_onion-1]) {
            for (j = [0 : length_onion-1]) {
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
    box(width_onion, onion_size, step_between_onions);
}
if (mode == "box_top") {
    box_top(width_onion, onion_size, step_between_onions);
}
if (mode == "onion_cup") {
    onion_cup();
}
