///@desc Rescale others objets

if( __newResSizeWidth == window_get_width() and __newResSizeHeight == window_get_height() ) {
	
	__isNewWindowSizeSetted = true;
	fn_resizeResolutionToObjects();
	
} else {

	alarm[1] = room_speed * 0.1;	
	
}