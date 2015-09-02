use <common.scad>;

boards_in_top = 6;
top_thickness = 13/16;

leg_offset = 3/8;
leg_length = 29;
leg_width = 2.75;

apron_thickness = 13/16;
apron_width = 5;
apron_overhang = 2.5;
apron_tenon_length = 3/8;
apron_overhang_end = apron_overhang;
leg_bracket_width = 4;

total_height = leg_length + top_thickness;
top_length = 12 * 7;
top_width = 40;

breadboard_width = 8;
breadboard_tenon_length = 2;
breadboard_mortice_length = 2.125;
breadboard_tenon_thickness = top_thickness / 2;
breadboard_tenon_shoulder_length = top_thickness;

color( "SaddleBrown" )
    top(
        boards_in_top=boards_in_top,
        breadboard_tenon_length=breadboard_tenon_length,
        breadboard_tenon_shoulder_length=breadboard_tenon_shoulder_length,
        breadboard_width=breadboard_width,
        top_length=top_length,
        top_thickness=top_thickness,
        top_width=top_width
    );

color( "ivory" ) union() {
    apron(
        apron_overhang=apron_overhang,
        apron_overhang_end=apron_overhang_end,
        apron_tenon_length=apron_tenon_length,
        apron_thickness=apron_thickness,
        apron_width=apron_width,
        top_length=top_length,
        leg_bracket_width=leg_bracket_width,
        leg_offset=leg_offset,
        leg_width=leg_width,
        top_width=top_width
    );
    legs(
        apron_overhang=apron_overhang_end,
        apron_overhang_end=apron_overhang_end,
        leg_bracket_width=leg_bracket_width,
        leg_length=leg_length,
        leg_offset=leg_offset,
        leg_width=leg_width,
        top_length=top_length,
        top_width=top_width
    );
}
