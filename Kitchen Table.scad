boards_in_top = 6;
table_top_thickness = 2;

leg_offset = 3/8;
leg_length = 29;
leg_width = 3;

apron_thickness = .75;
apron_width = 6;
apron_overhang = 2.5;
apron_tenon_length = 3/8;
apron_overhang_end = apron_overhang;

table_height = 30;
table_length = 12 * 7;
table_width = 40;

breadboard_width = 12;
breadboard_tenon_length = 2.5;
breadboard_mortice_length = 1.25;
breadboard_tenon_thickness = table_top_thickness / 2;
breadboard_tenon_shoulder_length = table_top_thickness;

color( "SaddleBrown" ) union() {
    tabletop();
}

color( "white" ) union() {
    apron();
    legs();
}

module board( size, label = false ) {
    // size[0] is always with the grain.
    // size[1] is against the grain.
    // size[2] is the board thickness.
    
    cube( size = size );
    
    // Output the size of the board for easy cut lists.
    echo( str( size[2], " ", label, ": ", size[0], "x", size[1], " ", (size[0] * size[1] * size[2] / 144), " board feet" ) );
}

module leg() {
    square_length = leg_length / 3;
    taper_length = leg_length * 2 / 3;
    rotate( [ 0, 90, 0 ] ) union() {        
        cube( size = [ square_length, leg_width, leg_width ] );
        translate( [ square_length, leg_width / 2, leg_width / 2 ] ) rotate( [ 0, 90, 0 ] ) cylinder( r1 = leg_width / 2, r2 = leg_width / 4, h = taper_length, $fn = 100 );
    }
}

module apron() {
    // Long apron pieces.
    translate( [ apron_overhang_end + leg_width - leg_offset, apron_overhang, 0 ] ) rotate( [ -90, 0, 0 ] ) board( size = [ table_length - ( apron_overhang_end * 2 ) - ( leg_width * 2 ) + ( leg_offset * 2 ), apron_width, apron_thickness ], label="apron" );
    translate( [ apron_overhang_end + leg_width - leg_offset, table_width - apron_thickness - apron_overhang, 0 ] ) rotate( [ -90, 0, 0 ] ) board( size = [ table_length - ( apron_overhang_end * 2 ) - ( leg_width * 2 ) + ( leg_offset * 2 ), apron_width, apron_thickness ], label="apron" );

    // Short apron sides.
    translate( [ apron_thickness + apron_overhang_end, apron_overhang - leg_offset + leg_width, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ table_width - ( apron_overhang * 2 ) + ( leg_offset * 2 ) - ( leg_width * 2 ), apron_width, apron_thickness ], label="apron" );
    translate( [ table_length - apron_overhang_end, apron_overhang + leg_width - leg_offset, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ table_width - ( apron_overhang * 2 ) + ( leg_offset * 2 ) - ( leg_width * 2 ), apron_width, apron_thickness ], label="apron" );

    apron_reinforcements = ceil(max( 0, ( table_length - ( apron_overhang_end * 2 ) - ( apron_thickness * 2 ) ) / 24 ));

    for ( i = [ 1 : apron_reinforcements ] ) {
        translate( [ apron_overhang_end + ( apron_thickness ) + ( i * ( table_length - ( 2 * apron_overhang_end ) ) / ( apron_reinforcements + 1 )), apron_overhang + apron_tenon_length, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ table_width - ( apron_overhang * 2 ) - ( apron_thickness * 2 ) + ( apron_tenon_length * 2 ), apron_width, apron_thickness ], label="apron" );
    }
    
    leg_bracket_a = ( leg_width - leg_offset ) * 2 - apron_thickness;
    leg_bracket_length = sqrt( pow( leg_bracket_a, 2 ) * 2 );

    // The corner brackets for attaching the legs.
    translate( [ apron_overhang + apron_thickness, table_width - apron_overhang - leg_bracket_a - apron_thickness, 0 ] ) rotate( [ -90, 0, 45 ] ) board( size = [ leg_bracket_length, apron_width, apron_thickness ] );
    translate( [ apron_overhang, apron_overhang + leg_bracket_a, 0 ] ) rotate( [ -90, 0, -45 ] ) board( size = [ leg_bracket_length, apron_width, apron_thickness ] );
    translate( [ table_length - leg_bracket_a - apron_overhang, apron_overhang, 0 ] ) rotate( [ -90, 0, 45 ] ) board( size = [ leg_bracket_length, apron_width, apron_thickness ] );
    translate( [ table_length - leg_bracket_a - apron_overhang - apron_thickness, table_width - apron_overhang - apron_thickness, 0 ] ) rotate( [ -90, 0, -45 ] ) board( size = [ leg_bracket_length, apron_width, apron_thickness ] );

}

module legs() {
    translate( [ apron_overhang_end - leg_offset, 0, 0 ] ) union() {
        translate( [ 0, apron_overhang - leg_offset, 0 ] ) leg();
        translate( [ 0, table_width - leg_width - apron_overhang + leg_offset, 0 ] ) leg();
    }
    
    translate( [ table_length - apron_overhang_end - leg_width + leg_offset, 0, 0 ] ) union() {
        translate( [ 0, apron_overhang - leg_offset, 0 ] ) leg();
        translate( [ 0, table_width - leg_width - apron_overhang + leg_offset, 0 ] ) leg();
    }
}

module tabletop() {
    for ( i = [ 1 : boards_in_top ] ) {
        translate( [ breadboard_width - breadboard_tenon_length, ( table_width * ( i - 1 ) ) / boards_in_top, 0 ] ) board( size = [ table_length - ( breadboard_width * 2 ) + (         breadboard_tenon_length * 2 ), ( table_width / boards_in_top ), table_top_thickness ], label="top" );
    }

    translate( [ breadboard_width, 0, 0 ] ) rotate( [ 0, 0, 90 ] ) board( size = [ table_width, breadboard_width, table_top_thickness ], label="top");
    translate( [ table_length, 0, 0 ] ) rotate( [ 0, 0, 90 ] ) board( size = [ table_width, breadboard_width, table_top_thickness ], label="top" );
}