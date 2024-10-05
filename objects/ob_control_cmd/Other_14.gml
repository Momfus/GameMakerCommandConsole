///@description Methods - Mouse and scroll


///@func	fn_CMDControl_inputMouse()
///@return	void
///@desc	Check all the inputs from the mouse
function fn_CMDControl_inputMouse() {
	
	#region Scrollbar move
	
		if( (_isCmdMouseWheelDown or _isCmdMouseWheelUp) and  _cmdMsgPositionTop < 0) {
			fn_CMDControl_scrollWindow( _isCmdMouseWheelDown - _isCmdMouseWheelUp );
		}
	
	#endregion
	
}

///@func	fn_CMDControl_scrollWindow(scrollDirection)
///@param	{real}	scrollDirection
///@return	void
///@desc	Check and calculate the scroll up with mouse or keyboard input
function fn_CMDControl_scrollWindow(p_scrollDirection) {

	_cmdWindowSurfaceYoffset += _cmdScrollSpeed * p_scrollDirection ;
	_cmdWindowSurfaceYoffset = clamp(_cmdWindowSurfaceYoffset,  _cmdMsgPositionTop, 0)
	
	fn_CMDWindow_updateSurface(false); 
	fn_CMDControl_updateScrollbarProperties(false, false);
	
}

///@func	fn_CMDControl_checkMouseEvent(scrollDirection)
///@return	void
///@desc	Check for mouse inputs when the CMD is open
function fn_CMDControl_checkMouseEvent() {
	
	_isCmdMouseWheelDown = mouse_wheel_down();
	_isCmdMouseWheelUp = mouse_wheel_up();
	
}