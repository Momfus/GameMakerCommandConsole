///@desc Methods - Begin Step

///@func	StateBeginStep_closed()
///@desc	Set the begin state when the cmd is closed
function StateBeginStep_closed() {
	  
	fn_CMDControl_checkSpecilKeyInput();
	if (__cmdKeyPressedShowHide) {
		fn_CMDControl_windowOpen();
	}
	
}

///@func	StateBeginStep_opened()
///@desc	Set the begin state when the cmd is opened
function StateBeginStep_opened() {
	
	if ( __currentState == enum_cmdState.opened ) {
  
		// Check first if the user want to close the cmd panel
		fn_CMDControl_checkSpecilKeyInput();
		if (__cmdKeyPressedShowHide) {
	    
			fn_CMDControl_windowClose();
			
		} else 
			
			// Input CMD
			fn_CMDControl_inputKeyboardUser();
			
			// Mouse event control
			fn_CMDControl_checkMouseEvent(); // Global mouse check (not necesarry when is hover the CMD

			__cmdMouseHover = fn_cmdGUICheckMouseIsHoverThisObject(__cmdMouseHover);
			if( __cmdMouseHover ) {
				fn_CMDControl_inputMouse();
			}

			
		}
			
}

///@func	fn_CMDControl_windowClose()
///@desc	Set the attributes necessary to close
function fn_CMDControl_windowClose() {
	__currentState = enum_cmdState.closed;
	__currentState_beginStep = StateBeginStep_closed;
	global.gCMDOpen = false;
	
	if( surface_exists(__surfCmdWindow) ) {
		surface_free(__surfCmdWindow);	
	}
}

///@func	fn_CMDControl_windowOpen()
///@desc	Set the attributes necessary to close
function fn_CMDControl_windowOpen() {
	__currentState = enum_cmdState.opened;
	__currentState_beginStep = StateBeginStep_opened;
	global.gCMDOpen = true;
}
