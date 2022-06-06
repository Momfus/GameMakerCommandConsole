/// @desc Display properties

fn_isSingleton();

__idealWidth = 0; // it calculate after for widescreen
__idealHeight = 270; // Change this to 0 for portrait
__zoom = 1;
__maxZoom = 1;

__aspectRatio = display_get_width() / display_get_height(); // aspectRatio > 1 -> Widescreen; < 1 -> portrait; = 1 -> square

__idealWidth = round(__idealHeight * __aspectRatio ); // Keep the height y change the width for widescreen
//__idealHeight = round(__idealWidth * __aspectRatio );  // Keep the width and change the height for portrait

/// Perfect Pixel Scaling
if( display_get_width() mod __idealWidth != 0 ) {

	var l_display = round( display_get_width() / __idealWidth );
	__idealWidth = display_get_width() / l_display;

}

if( display_get_height() mod __idealHeight != 0 ) {

	var l_display = round( display_get_height() / __idealHeight );
	__idealHeight = display_get_height() / l_display;

}

// Check for odd resolution numbers. Note: There is any "odd number resolution" but just in case, this will round into a even one
if( __idealWidth & 1 ) {
	__idealWidth++;
}

if( __idealHeight & 1 ) {
	__idealWidth++;
}

surface_resize(application_surface, __idealWidth, __idealHeight);
display_set_gui_size(__idealWidth, __idealHeight);
window_set_size(__idealWidth, __idealHeight);
alarm[0] = 1;
	
/// Calculate the maxZoom
__maxZoom = floor( display_get_width() / __idealWidth );
