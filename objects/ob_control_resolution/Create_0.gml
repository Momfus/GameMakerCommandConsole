/// @desc Attributes init

// This object must be in the beggining of the game in a blank room with the same size as the base widthxheight
fn_isSingleton();

__resShowInfo = true;
__resBaseWidth = 480; // Priorizate the Height for widescreen
__resBaseHeight = 270;

__resIdealWidth = __resBaseWidth;
__resIdealHeight = __resBaseHeight;

__resMaxWidth = 1920;
__resMaxHeight = 1080;

// Used as a multiplier with current to change some attributes size (like font size in the GUI layer)
__resGUIAspectOffset = 1;
__resGUIWidthOld = __resBaseWidth;

__resDisplayWidth =  display_get_width(); // Example: 1366
__resDisplayHeight = display_get_height(); // Example: 768

// Ini states (if you want to set fullscreen and another resolution in the beggining, create a ini file that is read and then excecute the resolution function
window_set_fullscreen(false);
window_set_size(__resBaseWidth, __resBaseHeight);

#region Functions

/// @function fn_controlResolutionResizeAll()
/// @param isFirsTimeStart: boolean
/// @param newWindowWidth: int
/// @param newWindowHeight: int
/// @return void
/// @desc Change the necesary attributes when the resolution is different.
function fn_controlResolutionResizeAll(p_isFirsTimeStart = false, p_newWindowWidth = __resBaseWidth, p_newWindowHeight = __resIdealHeight) {
	
	__resAspectRatio = __resDisplayWidth / __resDisplayHeight;
	
	__resIdealWidth = round( __resBaseHeight * __resAspectRatio ); // This is for widescreen aspect ratio (aspectRadio > 1);
	// __resIdealHeight = round( __resIdealWidth * __resAspectRatio ); /// This is for portrait aspect ratio (aspect ratio < 1),

	#region Perfect pixel scaling
	
		// Widescreen
		if ( (__resDisplayWidth mod __resIdealWidth ) != 0 ) { // Stretch to resolution to maintain dimensions
    
			var l_display = round( __resDisplayWidth / __resIdealWidth );
			__resIdealWidth = __resDisplayWidth / l_display;  
	
		}
	
		// Portrait (uncomment to enable and comment the other)
		//if ( ( __resDisplayHeight  mod __resIdealHeight ) != 0 ) { // Stretch to resolution to maintain dimensions
    
		//	var l_display = round(__resDisplayHeight / __resIdealHeight );
		//	__resIdealHeight =__resDisplayHeight / l_display;  
	
		//}
	
	
		// Check for odd resolution numbers. Note: There is any "odd number resolution" but just in case, this will round into a even one
		if( __resIdealWidth & 1 ) {
			__resIdealWidth++;
		}
	
		if( __resIdealHeight & 1 ) {
			__resIdealHeight++;
		}


	#endregion

	/// Set surface and center
	surface_resize(application_surface, __resIdealWidth, __resIdealHeight);

	fn_controlResolutionResizeGUI(p_newWindowWidth, p_newWindowHeight);

	alarm[0] = 1; // it need at lest one step to center the window
	
	// This is just to not generate a loop when the object is created (start with the base and if needed, call it again)
	if not( p_isFirsTimeStart) {
		fs_resizeResolutionToObjects();
	} else {
		room_goto_next();	
	}
}

/// @function fn_controlResolutionResizeGUI()
/// @param newGUIWidth: int
/// @param newGUIHeight: int
/// @return void
function fn_controlResolutionResizeGUI(p_newGUIWidth, p_newGUIHeight) {
	
	
	__resGUIWidthOld = display_get_gui_width();
	
	// Widescreen -> compare with Height for portrait
	if ( p_newGUIWidth > __resMaxWidth ) {
		__resGUIAspectOffset = __resMaxWidth / __resGUIWidthOld;
		display_set_gui_size(__resMaxWidth,__resMaxHeight);
	} else {
		__resGUIAspectOffset = p_newGUIWidth / __resGUIWidthOld;
		display_set_gui_size(p_newGUIWidth, p_newGUIHeight);	
	}

		
}

#endregion


fn_controlResolutionResizeAll(true); // Is important to call this in the beggining