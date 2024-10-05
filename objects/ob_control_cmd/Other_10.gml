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
	
	if ( _stateCurrent == e_stateCmd.opened ) {
  
		// Check first if the user want to close the cmd panel
		fn_CMDControl_checkSpecilKeyInput();
		if (__cmdKeyPressedShowHide) {
	    
			fn_CMDControl_windowClose();
			
		} else 
			
			// Input CMD
			fn_CMDControl_inputKeyboardUser();
			
			// Mouse event control
			fn_CMDControl_checkMouseEvent(); // Global mouse check (not necesarry when is hover the CMD

			_isCmdMouseHover = fn_cmdGUICheckMouseIsHoverThisObject(_isCmdMouseHover);
			if( _isCmdMouseHover ) {
				fn_CMDControl_inputMouse();
			}

			
		}
			
}

///@func	fn_CMDControl_windowClose()
///@desc	Set the attributes necessary to close
function fn_CMDControl_windowClose() {
	_stateCurrent = e_stateCmd.closed;
	_stateCurrentBeginStep = StateBeginStep_closed;
	global._gCmdOpen = false;
	
	if( surface_exists(_surfCmdWindow) ) {
		surface_free(_surfCmdWindow);	
	}
}

///@func	fn_CMDControl_windowOpen()
///@desc	Set the attributes necessary to close
function fn_CMDControl_windowOpen() {
	_stateCurrent = e_stateCmd.opened;
	_stateCurrentBeginStep = StateBeginStep_opened;
	global._gCmdOpen = true;
}
