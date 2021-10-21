/// @desc Methods - Begin Step

// @function StateBeginStep_closed();
// @desc Set the begin state when the cmd is closed
function StateBeginStep_closed() {
	  
	#region Check if the user want to open cmd
		var l_openCmd = fn_inputArrayCheckReleased( __cmdInputOpenKeyArray, __cmdInputOpenLength );
		if (l_openCmd) {
	    
			show_debug_message("Open cmd");
			__currentState = e_cmdState.opened;
			__currentState_beginStep = StateBeginStep_opened;
		
		}
	#endregion
	
}

// @function StateBeginStep_opened();
// @desc Set the begin state when the cmd is opened
function StateBeginStep_opened() {
	
	if ( __currentState == e_cmdState.opened ) {
  
		#region Check if the user want to close cmd
			var l_closeCmd = fn_inputArrayCheckReleased( __cmdInputCloseKeyArray, __cmdInputCloseLength );
		
			if (l_closeCmd) {
	    
				show_debug_message("Close cmd");
				__currentState = e_cmdState.closed;
				__currentState_beginStep = StateBeginStep_closed;
			}
		#endregion
		
		fn_controlCMD_inputKeyboardUser();
   
	}	
}

__currentState_beginStep = StateBeginStep_closed;