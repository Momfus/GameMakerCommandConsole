/// @description Methods - Mouse and scroll

/// @function fn_CMDControl_inputMouse()
/// @desc Check all the inputs from the mouse
function fn_CMDControl_inputMouse() {
	
	#region Scrollbar move
	
		var l_mouseWheelUp = mouse_wheel_up(),
			l_mouseWheelDown = mouse_wheel_down();
	
		if( l_mouseWheelUp || l_mouseWheelDown ) {
			fn_CMDControl_scrollWindow();
		}
	
	#endregion
	
	
	
}

/// @function fn_CMDControl_scrollUp()
/// @desc Check and calculate the scroll up with mouse or keyboard input
function fn_CMDControl_scrollWindow() {
	show_debug_message("scrollear")
	
	//__cmdWindowsScrollPosition -= __cmdScrollSpeed ;
	//__cmdWindowsScrollPosition = clamp(__cmdWindowsScrollPosition, 0, __heightLog);
	
	fn_CMDWindow_updateSurface();
}

