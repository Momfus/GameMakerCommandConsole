/// @description Methods - Mouse and scroll


/// @function fn_CMDControl_inputMouse()
/// @return void
/// @desc Check all the inputs from the mouse
function fn_CMDControl_inputMouse() {
	
	#region Scrollbar move
	
		if( (__cmdMouseWheelDown || __cmdMouseWheelUp) and  __cmdMsgTop < 0) {
			fn_CMDControl_scrollWindow( __cmdMouseWheelDown - __cmdMouseWheelUp );
		}
	
	#endregion
	
	
	
}

/// @function fn_CMDControl_scrollWindow(scrollDirection)
/// @param scrollDirection : int
/// @return void
/// @desc Check and calculate the scroll up with mouse or keyboard input
function fn_CMDControl_scrollWindow(p_scrollDirection) {

	__cmdWindowSurfaceYoffset += __cmdScrollSpeed * p_scrollDirection ;
	__cmdWindowSurfaceYoffset = clamp(__cmdWindowSurfaceYoffset,  __cmdMsgTop, 0)
	
	
	
	fn_CMDWindow_updateSurface();
}

/// @function fn_CMDControl_checkMouseEvent(scrollDirection)
/// @return void
/// @desc Check for mouse inputs when the CMD is open
function fn_CMDControl_checkMouseEvent() {
	
	__cmdMouseWheelDown = mouse_wheel_down();
	__cmdMouseWheelUp = mouse_wheel_up();
	
}