/// @desc Get keys status

// Check to see if the user had opened or closed the panel
if ( __currentState == e_cmdState.closed ) {
  
	var l_openCmd = fn_inputArrayCheckReleased( __cmdInputOpenKeyArray, __cmdInputOpenLength );
	// Open CMD
	if (l_openCmd) {
	    
		show_debug_message("Open cmd");
		__currentState = e_cmdState.opened;
		
	}

   
} else {

	if ( __currentState == e_cmdState.opened ) {
  
		var l_closeCmd = fn_inputArrayCheckReleased( __cmdInputCloseKeyArray, __cmdInputCloseLength );
		// Open CMD
		if (l_closeCmd) {
	    
			show_debug_message("Close cmd");
			__currentState = e_cmdState.closed;
		
		}
   
	}
	
}
