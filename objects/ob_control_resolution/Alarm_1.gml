///@desc Rescale others objets

if( _newResSizeWidth == window_get_width() and _newResSizeHeight == window_get_height() ) {
	
	_isNewWindowSizeSetted = true;
	// Feather disable once GM2016
	_mtResizeResolutionToObjects();
	
} else {

	alarm[1] = fn_getCurrentFps() * 0.1;	
	
}