///@desc Methods - Begin Step

// Feather disable GM2016

///@func	_mtStateBeginStepCMDClosed()
///@desc	Set the begin state when the cmd is closed
function _mtStateBeginStepCMDClosed() {
	  
	_mtInputCheckSpecialKey();
	if (_cmdKeyPressedShowHide) {
		_mtConsoleWindowOpen();
	}
	
}

///@func	_mtStateBeginStepCMDOpened()
///@desc	Set the begin state when the cmd is opened
function _mtStateBeginStepCMDOpened() {
	
	if ( _stateCurrent == e_stateCmd.opened ) {
  
		// Check first if the user want to close the cmd panel
		_mtInputCheckSpecialKey();
		if (_cmdKeyPressedShowHide) {
	    
			_mtConsoleWindowClose();
			
		} else 
			
			// Input CMD
			_mtCMDInputKeyboardUser();
			
			// Mouse event control
			fn_CMDControl_checkMouseEvent(); // Global mouse check (not necesarry when is hover the CMD)

			_isCmdMouseHover = fn_cmdGUICheckMouseIsHoverThisObject(_isCmdMouseHover);
			if( _isCmdMouseHover ) {
				fn_CMDControl_inputMouse();
			}

		}
			
}

///@func	_mtConsoleWindowClose()
///@desc	Set the attributes necessary to close
function _mtConsoleWindowClose() {
	_stateCurrent = e_stateCmd.closed;
	_stateCurrentBeginStep = _mtStateBeginStepCMDClosed;
	global._gCmdOpen = false;
	
	if( surface_exists(_surfCmdWindow) ) {
		surface_free(_surfCmdWindow);	
	}
}

///@func	_mtConsoleWindowOpen()
///@desc	Set the attributes necessary to close
function _mtConsoleWindowOpen() {
	_stateCurrent = e_stateCmd.opened;
	_stateCurrentBeginStep = _mtStateBeginStepCMDOpened;
	global._gCmdOpen = true;
}
