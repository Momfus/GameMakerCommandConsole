///@desc Attributes init

/**************************************************************************************************************************
	IMPORTANT: This object must be in the beggining of the game in a blank room with the same size as the base widthxheight
/**************************************************************************************************************************/


#region Methods

	///@func	_mtControlResolutionResizeAll()
	///@param	{bool}	[p_isFirstTimeStart]
	///@param	{real}	[p_newWindowWidth]
	///@param	{real}	[p_newWindowHeight]
	///@param	{bool}	[p_isPortrait]
	///@return	void
	///@desc	Change the necesary attributes when the resolution is different.
	function _mtControlResolutionResizeAll(p_isFirstTimeStart = false, p_newWindowWidth = _resBaseWidth, p_newWindowHeight = _resIdealHeight,  p_isPortrait = false) {
	
		_isNewWindowSizeSetted = false;
	
		var l_isWindowFS = window_get_fullscreen(),
			l_displayReferenceWidth = l_isWindowFS ? _resDisplayWidth : p_newWindowWidth,
			l_displayReferenceHeight = l_isWindowFS ? _resDisplayHeight : p_newWindowHeight;

	
		_resAspectRatio = l_displayReferenceWidth / l_displayReferenceHeight;
	
		if not( p_isPortrait ) {
			_resIdealWidth = round( _resBaseHeight * _resAspectRatio ); // This is for widescreen aspect ratio (aspectRadio > 1);	
			_resIdealHeight = _resBaseHeight;
		} else{
			_resIdealHeight = round( _resBaseWidth * _resAspectRatio ); // This is for portrait aspect ratio (aspectRadio < 1);		
			_resIdealWidth = _resBaseWidth;
		}

		#region Perfect pixel scaling
	
			// For test purposes, is important to adjust not only the width but the height also, it works for differents ratios fixing the camera width and height then 
		
			// Widescreen
			if ( ( not(p_isPortrait) and (l_displayReferenceWidth mod _resIdealWidth ) != 0 ) or not(l_isWindowFS) ) { // Stretch to resolution to maintain dimensions
    
				var l_display = round( l_displayReferenceWidth / _resIdealWidth );
				_resIdealWidth = round(l_displayReferenceWidth / l_display);
			
	
			}
	
			// Portrait (uncomment to enable and comment the other)
			if ( ( p_isPortrait and ( l_displayReferenceHeight  mod _resIdealHeight ) != 0 ) or not(l_isWindowFS) ) { // Stretch to resolution to maintain dimensions
				var l_display = round(l_displayReferenceHeight / _resIdealHeight );
				_resIdealHeight =l_displayReferenceHeight / l_display;  
	
			}
	
	
			// Check for odd resolution numbers. Note: There is any "odd number resolution" but just in case, this will round into a even one
			if( _resIdealWidth & 1 ) {
				_resIdealWidth++;
			}
	
			if( _resIdealHeight & 1 ) {
				_resIdealHeight++;
			}


		#endregion

		/// Set surface and center
	
		window_set_size(p_newWindowWidth, p_newWindowHeight);
	
		surface_resize(application_surface,_resIdealWidth,_resIdealHeight);
	
		_mtControlResolutionResizeGUI(p_newWindowWidth, p_newWindowHeight);

		alarm[0] = 1; // it need at lest one step to center the window
	
		// Checkers for news resize
		if( window_get_fullscreen() ) {
			_newResSizeWidth = _resDisplayWidth;
			_newResSizeHeight = _resDisplayHeight;
		} else {
			_newResSizeWidth = (p_newWindowWidth > _resDisplayWidth )? _resDisplayWidth : p_newWindowWidth;
			_newResSizeHeight = (p_newWindowHeight > _resDisplayHeight)? _resDisplayHeight : p_newWindowHeight;
		}
	
		// This is just to not generate a loop when the object is created (start with the base and if needed, call it again)
		if not( p_isFirstTimeStart) {
			alarm[1] = fn_getCurrentFps(); // It need at least one step after the rescale is made
		} else {
			_isNewWindowSizeSetted = true;
			room_goto_next();	
		}
	
	
	}

	///@func	_mtControlResolutionResizeGUI()
	///@param	{real}	p_newGUIWidth
	///@param	{real}	p_newGUIHeight
	///@return	void
	function _mtControlResolutionResizeGUI(p_newGUIWidth, p_newGUIHeight) {
	
		_resGUIWidthOld = display_get_gui_width();
	
		// Widescreen -> compare with Height for portrait
		if ( p_newGUIWidth > _resMaxWidth ) {
			_resGUIAspectOffset = _resMaxWidth / _resGUIWidthOld;
			display_set_gui_size(_resMaxWidth,_resMaxHeight);
		} else {
			_resGUIAspectOffset = p_newGUIWidth / _resGUIWidthOld;
			display_set_gui_size(p_newGUIWidth, p_newGUIHeight);	
		}
		
	}

	///@func	mtResizeResolutionToObjects()
	///@return	void
	///@desc	It used to resize all the objets that depend on the resolution size (like camera and gui elements) 
	function _mtResizeResolutionToObjects() {

		ob_camera_main._mtResizeWindow();
		ob_control_cmd._mtResizeWindow(_resGUIAspectOffset);
	
	}

#endregion

// Object Init

application_surface_draw_enable(false);
fn_isSingleton();

_isResInfoShow = true;
_resBaseWidth = 960; // Priorizate the Height for widescreen
_resBaseHeight = 540;

_resIdealWidth = _resBaseWidth;
_resIdealHeight = _resBaseHeight;

_resMaxWidth = 1920;
_resMaxHeight = 1080;


// Check helpers (for GUI resize)
_newResSizeWidth = 0;
_newResSizeHeight = 0;

// Used as a multiplier with current to change some attributes size (like font size in the GUI layer)
_resGUIAspectOffset = 1;
_resGUIWidthOld = _resBaseWidth;

_resDisplayWidth =   display_get_width();
_resDisplayHeight =  display_get_height();
_isNewWindowSizeSetted = false;


// Ini states (if you want to set fullscreen and another resolution in the beggining, create a ini file that is read and then excecute the resolution function
window_set_fullscreen(false);
window_set_size(_resBaseWidth, _resBaseHeight);



_mtControlResolutionResizeAll(true); // Is important to call this in the beggining

