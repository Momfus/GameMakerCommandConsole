/// @function fn_CMDControl_commitInput( commitInput )
/// @param commitInput: String
/// @return void
/// @desc Control the input to commit
function fn_CMDControl_commitInput(p_commitInput) {

	if( p_commitInput == "" || p_commitInput == noone || p_commitInput == undefined ) {
		exit;
	}
	
		
	// Separate the input in an array command to check (ignore the spaces) and check if is valid
	__cmdTextPartArray = fn_stringSplit(p_commitInput, " ", true);
	
	if( array_length(__cmdTextPartArray) == undefined ) { 
		
		var l_tempTextError = "[ERROR] Empty command sent";
		fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_tempTextError);
		
	} else {
	
		fn_cmdArrayPushFIFO(__cmdLogArrayInput, p_commitInput);
		fn_CMDControl_parseCommand();
	
	}
	
	if( __cmdLogMsgCountCurrent != __cmdLogCountMax ) {
		__cmdLogMsgCountCurrent = fn_cmdGetArrayStringSizeNoEmpty(__cmdLogArrayMsg);
	}
	
	// Clean old message input
	__cmdText[e_cmdTextInput.leftSide] = "";
	__cmdText[e_cmdTextInput.rightSide] = "";
	__cmdCursorPosition = 0;
	
	// Reset the text part array
	__cmdTextPartArray = undefined;
	__cmdTextPartArray[0] = "";
	
	__cmdWindowSurfaceYoffset = 0; // Go to the bottom of the CMD log window
	fn_CMDWindow_updateSurface();

}

/// @function fn_CMDControl_parseCommand()
/// @return void
/// @desc Check the command type added and resolve the input
function fn_CMDControl_parseCommand() {
	
	// @TODO: Delete this, is just for test before submit a new version
	var l_tempJoinText = "";
	for( var i = 0; i < array_length(__cmdTextPartArray); i++) {
		show_debug_message(__cmdTextPartArray[i])
		l_tempJoinText += __cmdTextPartArray[i] + " ";
	}
	
	// @TODO: Delete this after add the correct check and validator
	//fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_tempJoinText );
	
	switch(__cmdTextPartArray[0]) {
	
		case __cmdCommand[e_command.versionLong]:
		case __cmdCommand[e_command.versionShort]: {
			
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, fn_CMDControl_inputGetStringVersion() );
			break;
		
		}
		
		case __cmdCommand[e_command.clear]: {
			
			__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");
			__cmdLogMsgCountCurrent = 0;
			break;
			
		}
		
		case __cmdCommand[e_command.help]: {
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, fn_CMDControl_inputGetStringHelp() );
			break;
		}
		
		default: {
		
			var l_tempTextError = "[ERROR] The '" + __cmdTextPartArray[0] + "' command isn't recognized" ;
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_tempTextError);
		
			break;
		
		}
	
	}
	
}




/// @function fn_CMDControl_inputGetStringVersion()
/// @return string
/// @desc A auxiliar function that give the complete version string to show
function fn_CMDControl_inputGetStringVersion() {
	return 
	@"=============================
	===  GMS2 Console Command  ===
	========  by Crios Devs  ========
	=============================
	========  Version:   " 
	+ string(CMD_CURRENT_VERSION) 
	+ @"	 ========
	=============================" ;
}

/// @function fn_CMDControl_inputGetStringHelp()
/// @return string
/// @desc A auxiliar function that give the complete version string to show
function fn_CMDControl_inputGetStringHelp() {
	return 
	@"==== HELP ====
	version|v
	   - Get gms2CMD version
	help
	   - Show the most commons commands
	clear
	   - Clean the console log
	===============";
}