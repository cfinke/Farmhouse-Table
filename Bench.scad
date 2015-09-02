use <common.scad>;

boards_in_top = 2;
top_thickness = 26/16;

apron_thickness = 13/16;
apron_width = 3;
apron_overhang = 1;
apron_tenon_length = 3/8;
apron_overhang_end = apron_overhang;
leg_bracket_width = 4;

total_height = 17;
top_length = 12 * 6;
top_width = 14;

leg_offset = 3/8;
leg_width = 2.75;

breadboard_width = 0;
breadboard_tenon_length = 0;
breadboard_mortice_length = 0;
breadboard_tenon_thickness = 0;
breadboard_tenon_shoulder_length = 0;

leg_length = total_height - top_thickness;

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
