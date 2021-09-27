/// @desc Methods - Begin Step

function StateBeginStep_closed() {
	  
	var l_openCmd = fn_inputArrayCheckReleased( __cmdInputOpenKeyArray, __cmdInputOpenLength );
	// Open CMD
	if (l_openCmd) {
	    
		show_debug_message("Open cmd");
		__currentState = e_cmdState.opened;
		__currentState_beginStep = StateBeginStep_opened;
		
	}
	
}

function StateBeginStep_opened() {
	
	if ( __currentState == e_cmdState.opened ) {
  
		var l_closeCmd = fn_inputArrayCheckReleased( __cmdInputCloseKeyArray, __cmdInputCloseLength );
		// Open CMD
		if (l_closeCmd) {
	    
			show_debug_message("Close cmd");
			__currentState = e_cmdState.closed;
			__currentState_beginStep = StateBeginStep_closed;
		}
   
	}	
}

__currentState_beginStep = StateBeginStep_closed;