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
		fn_CMDArrayPushFIFO(__cmdLogArrayMsg, l_tempTextError);
		
	} else {
	
		fn_CMDArrayPushFIFO(__cmdLogArrayInput, p_commitInput);
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
	
	fn_CMDWindow_updateSurface(true);
	
	if( __cmdMsgTop < 0 ) {
		fn_CMDControl_updateScrollbarProperties(true, true);
	}

}


/// @function fn_CMDControl_updateScrollbarProperties(updatePositionX, updateHeight)
/// @param updatePositionX: boolean
/// @param updateHeight: boolean
/// @return void
/// @desc Update the visual properties to show the scrollbar (sometimes there is no need to update the X position or the height)
function fn_CMDControl_updateScrollbarProperties (p_updatePositionX, p_updateHeight) {
		
	if( p_updatePositionX ) {
		__cmdScrollBarTapPositionX = x + __width - __cmdScrollBarTapWidth;
	}
	
	if( p_updateHeight ) {
		var l_heightLogOffset = __heightLog - 2,
			l_heightRelativeScrollbar = l_heightLogOffset / __cmdMsgWindowHeight;
		
		__cmdScrollBarTapHeight = clamp(l_heightRelativeScrollbar * l_heightLogOffset, __cmdScrollBarTapHeightMin, l_heightLogOffset);
		__cmdScrollBarTapRelativeEmptySpace = l_heightLogOffset - __cmdScrollBarTapHeight;
	}

	__cmdScrollBarTapPositionOffset = (__cmdScrollBarTapRelativeEmptySpace * __cmdWindowSurfaceYoffset ) / (-__cmdMsgTop);
	
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
	//fn_CMDArrayPushFIFO(__cmdLogArrayMsg, l_tempJoinText );
	
	switch(__cmdTextPartArray[0]) {
	
		case __cmdCommand[e_command.versionLong]:
		case __cmdCommand[e_command.versionShort]: {
			
			fn_CMDArrayPushFIFO(__cmdLogArrayMsg, fn_CMDControl_inputGetStringVersion() );
			break;
		
		}
		
		case __cmdCommand[e_command.clear]: {
			
			fn_CMDControl_clearLog();
			break;
			
		}
		
		case __cmdCommand[e_command.help]: {
			fn_CMDArrayPushFIFO(__cmdLogArrayMsg, fn_CMDControl_inputGetStringHelp() );
			break;
		}
		
		default: {
		
			var l_tempTextError = "[ERROR] The '" + __cmdTextPartArray[0] + "' command isn't recognized" ;
			fn_CMDArrayPushFIFO(__cmdLogArrayMsg, l_tempTextError);
		
			break;
		
		}
	
	}
	
}

/// @function objCommand(title, shortTitle, description, [function], [arguments], [argsDescription])
/// @return newCommand: ligthObject
/// @desc Create a command object
function objCommand(p_title, p_shortTitle, p_description, p_function = undefined, p_arguments = undefined, p_argsDescription = undefined ) constructor {
	cmdTitle = p_title;
	cmdShort = p_shortTitle;
	cmdDesc = p_description;
	cmdFunc = p_function;
	cmdArgs = p_arguments;
	cmdArgDesc = p_argsDescription;
}

/// @function fn_CMDControl_getCommands()
/// @return commandList: [ligthObject]
/// @desc Get the commands available with their properties and binding function
function fn_CMDControl_getCommands() {
	
	#region Command List
	
	var l_commandList = [
	
		// Header
		new objCommand("Title", "Short", "Description"),
		
		// Help
		new objCommand("help", "h", 
			"Show all the help about commands",
			fn_CMDControl_getCommands,
			["command"],
			["It show a more detail description about an specific command"]),
		
		// Version
		new objCommand("version", "v", 
			"Show the current gms2CMD version",
			fn_CMDControl_inputGetStringVersion),
		
		// Clear
		new objCommand("clear", "-",
			"Clear the current console log (it also reset the command history)",
			fn_CMDControl_inputGetStringVersion),

		
	];
	
	#endregion
	
	return l_commandList
	

}

//----------------------------
#region Commands action list

/// @function fn_CMDControl_clearLog()
/// @return void
/// @desc Clear the current console log (it also reset the command history)
function fn_CMDControl_clearLog() {
	__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");
	__cmdLogMsgCountCurrent = 0;
}

/// @function fn_CMDControl_inputGetStringVersion()
/// @return string
/// @desc A auxiliar function that give the complete version string to show
function fn_CMDControl_inputGetStringVersion() {
	return 
	@"==============================
	===  GMS2 Console Command  ===
	======  by Crios Devs  =======
	==============================
	> Version:   " + string(CMD_CURRENT_VERSION) + 
	"\n==============================" ;
}

/// @function fn_CMDControl_inputGetStringHelp()
/// @return helpText: string
/// @desc A auxiliar function that give the complete version string to show
function fn_CMDControl_inputGetStringHelp() {
	var l_helpText = "==== HELP ====",
		l_cmdCommands = fn_CMDControl_getCommands(),
		l_cmdCommandsLength = array_length(l_cmdCommands);
		
	for( var i = 0; i < l_cmdCommandsLength; i++ ) {
		
		var l_cmdTitle = string_upper(l_cmdCommands[i].cmdTitle),
			l_cmdShortTitle = string_upper(l_cmdCommands[i].cmdShort),
			l_cmdDescription = l_cmdCommands[i].cmdDesc;
			
		l_helpText += "\n" + fn_stringAddPad(l_cmdTitle, 10) +
						fn_stringAddPad(l_cmdShortTitle, 8) +
						l_cmdDescription;
	}
	
	l_helpText += "\n===============";
	
	return l_helpText; 
}

#endregion


