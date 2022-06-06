/// @desc Attributes init

fn_isSingleton();

__resShowInfo = true;
__resBaseWidth = 960; // Priorizate the Height for widescreen
__resBaseHeight = 540;

__resMaxWidth = 1920;
__resMaxHeight = 1080;

__resWindowSizeCurrent = window_get_width() / window_get_width();
__resWindowSizeOld = __resWindowSizeCurrent; // Used as a multiplier with current to change some attributes size (like font size in the GUI layer)


#region Functions

/// @function fn_controlResolutionResize()
/// @param isFirsTimeStart: boolean
/// @return void
/// @desc Change the necesary attributes when the resolution is different.
function fn_controlResolutionResize(p_isFirsTimeStart = false) {
	
	var l_displayWidth =  display_get_width(),
		l_displayHeight = display_get_height();
	
	__resAspectRatio =l_displayWidth / l_displayHeight;

	__resWindowSizeOld = __resWindowSizeCurrent;
	__resWindowSizeCurrent = window_get_width() / window_get_width();

	__resIdealWidth = round( __resBaseHeight * __resAspectRatio ); // This is for widescreen aspect ratio (aspectRadio > 1);
	__resIdealHeight = __resBaseHeight;

	/// Perfect pixel scaling
	if ( ( display_get_width() mod __resIdealWidth ) != 0 ) { // Stretch to resolution to maintain dimensions
    
		var l_display = round( display_get_width() / __resIdealWidth );
		__resIdealWidth = display_get_width() / l_display;  
	
	}

	// Check for odd resolution numbers. Note: There is any "odd number resolution" but just in case, this will round into a even one
	if( __resIdealWidth & 1 ) {
		__resIdealWidth++;
	}

	/// Set surface and center
	surface_resize(application_surface, __resIdealWidth, __resIdealHeight);

	if( window_get_fullscreen() ) {
		
		if( l_displayWidth > __resMaxWidth ) {
			display_set_gui_size(__resMaxWidth, __resMaxHeight);
		} else {
			display_set_gui_size(l_displayWidth, l_displayHeight);	
		}
				
	} else {
		window_set_size(__resIdealWidth, __resIdealHeight);	
		display_set_gui_size(__resIdealWidth, __resIdealHeight);
	}

	alarm[0] = 1;
	
	if not( p_isFirsTimeStart) {
		fs_resizeResolutionToObjects();
	}
	
}

#endregion


fn_controlResolutionResize(true); // Is important to call this in the beggining
