///@description Methods - Mouse and scroll


///@func	_mtCMDInputMouseControl()
///@desc	Check all the inputs from the mouse
function _mtCMDInputMouseControl() {
	
	#region Scrollbar move
	
		if( (_isCmdMouseWheelDown or _isCmdMouseWheelUp) and  _cmdMsgPositionTop < 0) {
			// Feather disable once GM1009
			_mtCMDScrollWindowControl( _isCmdMouseWheelDown - _isCmdMouseWheelUp );
		}
	
	#endregion
	
}

///@func	_mtCMDScrollWindowControl(scrollDirection)
///@param	{real}	p_scrollDirection
///@desc	Check and calculate the scroll up with mouse or keyboard input
function _mtCMDScrollWindowControl(p_scrollDirection) {

	_cmdWindowSurfaceYoffset += _cmdScrollSpeed * p_scrollDirection ;
	_cmdWindowSurfaceYoffset = clamp(_cmdWindowSurfaceYoffset,  _cmdMsgPositionTop, 0)
	
	_mtCMDWindowUpdateSurface(false); 
	_mtConsoleUpdateScrollbarProperties(false, false);
	
}

///@func	_mtCMDCheckMouseEventControl(scrollDirection)
///@return	void
///@desc	Check for mouse inputs when the CMD is open
function _mtCMDCheckMouseEventControl() {
	
	_isCmdMouseWheelDown = mouse_wheel_down();
	_isCmdMouseWheelUp = mouse_wheel_up();
	
}