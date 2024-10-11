///@desc Methods - Begin Step

///@func	_mtStateBeginStepCMDClosed()
///@desc	Set the begin state when the cmd is closed
function _mtStateBeginStepCMDClosed() {
	  
	fn_CMDControl_checkSpecilKeyInput();
	if (_cmdKeyPressedShowHide) {
		_mtCMDWindowOpen();
	}
	
}

///@func	_mtStateBeginStepCMDOpened()
///@desc	Set the begin state when the cmd is opened
function _mtStateBeginStepCMDOpened() {
	
	if ( _stateCurrent == e_stateCmd.opened ) {
  
		// Check first if the user want to close the cmd panel
		fn_CMDControl_checkSpecilKeyInput();
		if (_cmdKeyPressedShowHide) {
	    
			_mtCMDWindowClose();
			
		} else 
			
			// Input CMD
			fn_CMDControl_inputKeyboardUser();
			
			// Mouse event control
			fn_CMDControl_checkMouseEvent(); // Global mouse check (not necesarry when is hover the CMD)

			_isCmdMouseHover = fn_cmdGUICheckMouseIsHoverThisObject(_isCmdMouseHover);
			if( _isCmdMouseHover ) {
				fn_CMDControl_inputMouse();
			}

		}
			
}

///@func	_mtCMDWindowClose()
///@desc	Set the attributes necessary to close
function _mtCMDWindowClose() {
	_stateCurrent = e_stateCmd.closed;
	_stateCurrentBeginStep = _mtStateBeginStepCMDClosed;
	global._gCmdOpen = false;
	
	if( surface_exists(_surfCmdWindow) ) {
		surface_free(_surfCmdWindow);	
	}
}

///@func	_mtCMDWindowOpen()
///@desc	Set the attributes necessary to close
function _mtCMDWindowOpen() {
	_stateCurrent = e_stateCmd.opened;
	_stateCurrentBeginStep = _mtStateBeginStepCMDOpened;
	global._gCmdOpen = true;
}
