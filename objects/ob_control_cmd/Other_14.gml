/// @description Methods - Mouse and scroll

/// @function fn_CMDControl_inputMouse()
/// @desc Check all the inputs from the mouse
function fn_CMDControl_inputMouse() {
	
	#region Scrollbar move
	
		if( mouse_wheel_up() or __cmdKeyMoveArrowKeyUp ) {
			fn_CMDControl_scrollUp();
		} else {
			if( mouse_wheel_down() or __cmdKeyMoveArrowKeyDown ) {
				fn_CMDControl_scrollDown();	
			}
		}
	
	#endregion
	
	
	
}

/// @function fn_CMDControl_scrollUp()
/// @desc Check and calculate the scroll up with mouse or keyboard input
function fn_CMDControl_scrollUp() {
	show_debug_message("subir UP")
	__windowTop -= __cmdScrollSpeed;
	
	__windowTop = clamp(__windowTop, 0, __heightLog);
}

/// @function fn_CMDControl_scrollDown()
/// @desc Check and calculate the scroll down with mouse or keyboard input
function fn_CMDControl_scrollDown() {
	show_debug_message("bajar Down");
	
	
	__windowTop += __cmdScrollSpeed;
	__windowTop = clamp(__windowTop, 0, __heightLog);
}

