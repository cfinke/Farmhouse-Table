module board( size, label = false ) {
    // size[0] is always with the grain.
    // size[1] is against the grain.
    // size[2] is the board thickness.
    
    cube( size = size );
    
    // Output the size of the board for easy cut lists.
    echo( str( size[2], " ", label, ": ", size[0], "x", size[1], " ", (size[0] * size[1] * size[2] / 144), " board feet" ) );
}

module leg( leg_length, leg_width ) {
    square_length = leg_length / 3;
    taper_length = leg_length * 2 / 3;
    rotate( [ 0, 90, 0 ] ) union() {
        cube( size = [ square_length, leg_width, leg_width ] );
        translate( [ square_length, leg_width / 2, leg_width / 2 ] ) rotate( [ 0, 90, 0 ] ) cylinder( r1 = leg_width / 2, r2 = leg_width / 4, h = taper_length, $fn = 100 );
    }
}

module apron( apron_overhang_end, leg_width, leg_offset, apron_overhang, top_length, apron_thickness, apron_width, top_width, apron_tenon_length, leg_bracket_width ) {
    // Long apron pieces.
    translate( [ apron_overhang_end + leg_width - leg_offset, apron_overhang, 0 ] ) rotate( [ -90, 0, 0 ] ) board( size = [ top_length - ( apron_overhang_end * 2 ) - ( leg_width * 2 ) + ( leg_offset * 2 ), apron_width, apron_thickness ], label="apron" );
    translate( [ apron_overhang_end + leg_width - leg_offset, top_width - apron_thickness - apron_overhang, 0 ] ) rotate( [ -90, 0, 0 ] ) board( size = [ top_length - ( apron_overhang_end * 2 ) - ( leg_width * 2 ) + ( leg_offset * 2 ), apron_width, apron_thickness ], label="apron" );

    // Short apron sides.
    translate( [ apron_thickness + apron_overhang_end, apron_overhang - leg_offset + leg_width, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ top_width - ( apron_overhang * 2 ) + ( leg_offset * 2 ) - ( leg_width * 2 ), apron_width, apron_thickness ], label="apron" );
    translate( [ top_length - apron_overhang_end, apron_overhang + leg_width - leg_offset, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ top_width - ( apron_overhang * 2 ) + ( leg_offset * 2 ) - ( leg_width * 2 ), apron_width, apron_thickness ], label="apron" );

    apron_reinforcements = ceil(max( 0, ( top_length - ( apron_overhang_end * 2 ) - ( apron_thickness * 2 ) ) / 30 ));

    for ( i = [ 1 : apron_reinforcements ] ) {
        translate( [ apron_overhang_end + ( apron_thickness ) + ( i * ( top_length - ( 2 * apron_overhang_end ) ) / ( apron_reinforcements + 1 )), apron_overhang + apron_tenon_length, 0 ] ) rotate( [ -90, 0, 90 ] ) board( size = [ top_width - ( apron_overhang * 2 ) - ( apron_thickness * 2 ) + ( apron_tenon_length * 2 ), apron_width, apron_thickness ], label="apron" );
    }
    
    leg_bracket_a = ( leg_width - leg_offset ) * 2 - apron_thickness;
    leg_bracket_length = sqrt( pow( leg_bracket_a, 2 ) * 2 );

    translate( [ 0, 0, - ( apron_width - leg_bracket_width ) / 2 ] ) union() {
        // The corner brackets for attaching the legs.
        translate( [ apron_overhang + apron_thickness, top_width - apron_overhang - leg_bracket_a - apron_thickness, 0 ] ) rotate( [ -90, 0, 45 ] ) board( size = [ leg_bracket_length, leg_bracket_width, apron_thickness ], label = "leg bracket" );
        translate( [ apron_overhang, apron_overhang + leg_bracket_a, 0 ] ) rotate( [ -90, 0, -45 ] ) board( size = [ leg_bracket_length, leg_bracket_width, apron_thickness ], label = "leg bracket" );
        translate( [ top_length - leg_bracket_a - apron_overhang, apron_overhang, 0 ] ) rotate( [ -90, 0, 45 ] ) board( size = [ leg_bracket_length, leg_bracket_width, apron_thickness ], label = "leg bracket" );
        translate( [ top_length - leg_bracket_a - apron_overhang - apron_thickness, top_width - apron_overhang - apron_thickness, 0 ] ) rotate( [ -90, 0, -45 ] ) board( size = [ leg_bracket_length, leg_bracket_width, apron_thickness ], label = "leg bracket" );
    }
}

module legs( leg_length, leg_width, apron_overhang_end, leg_offset, apron_overhang, top_width, top_length ) {
    translate( [ apron_overhang_end - leg_offset, 0, 0 ] ) union() {
        translate( [ 0, apron_overhang - leg_offset, 0 ] ) leg( leg_length=leg_length, leg_width=leg_width );
        translate( [ 0, top_width - leg_width - apron_overhang + leg_offset, 0 ] ) leg( leg_length=leg_length, leg_width=leg_width );
    }

    translate( [ top_length - apron_overhang_end - leg_width + leg_offset, 0, 0 ] ) union() {
        translate( [ 0, apron_overhang - leg_offset, 0 ] ) leg( leg_length=leg_length, leg_width=leg_width );
        translate( [ 0, top_width - leg_width - apron_overhang + leg_offset, 0 ] ) leg( leg_length=leg_length, leg_width=leg_width );
    }
}

module top( boards_in_top, breadboard_width, breadboard_tenon_length, top_width, top_length, top_thickness, breadboard_tenon_shoulder_length ) {
    difference() {
        union() {
            for ( i = [ 1 : boards_in_top ] ) {
                translate( [ breadboard_width - breadboard_tenon_length, ( top_width * ( i - 1 ) ) / boards_in_top, 0 ] ) board( size = [ top_length - ( breadboard_width * 2 ) + ( breadboard_tenon_length * 2 ), ( top_width / boards_in_top ), top_thickness ], label="top" );
            }
        
            translate( [ breadboard_width, 0, 0 ] ) rotate( [ 0, 0, 90 ] ) board( size = [ top_width, breadboard_width, top_thickness ], label="top");
            translate( [ top_length, 0, 0 ] ) rotate( [ 0, 0, 90 ] ) board( size = [ top_width, breadboard_width, top_thickness ], label="top" );
        }
        
        union() {
            translate( [ breadboard_width - breadboard_tenon_length, 0, 0 ] ) cube( [ breadboard_tenon_length, breadboard_tenon_shoulder_length, top_thickness ] );
            translate( [ breadboard_width - breadboard_tenon_length, top_width - breadboard_tenon_shoulder_length, 0 ] ) cube( [ breadboard_tenon_length, breadboard_tenon_shoulder_length, top_thickness ] );
            translate( [ top_length - breadboard_width, top_width - breadboard_tenon_shoulder_length, 0 ] ) cube( [ breadboard_tenon_length, breadboard_tenon_shoulder_length, top_thickness ] );
            translate( [ top_length - breadboard_width, 0, 0 ] ) cube( [ breadboard_tenon_length, breadboard_tenon_shoulder_length, top_thickness ] );
        }
    }
}