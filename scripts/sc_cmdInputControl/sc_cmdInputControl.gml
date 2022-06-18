function sc_cmdInputControl() {	

/// General variables for this functions
__currentCommandExecute = undefined;


/// @function objCommand(title, shortTitle, description, [function], [arguments], [argsDescription])
/// @return newCommand: ligthObject
/// @desc Create a command object
function objCommand(p_title, p_shortTitle, p_description, p_function = undefined, p_arguments = undefined, p_argsDescription = undefined ) constructor {
	__cmdTitle = p_title;
	__cmdShort = p_shortTitle;
	__cmdDesc = p_description;
	__cmdFunc = p_function;
	__cmdArgs = p_arguments;
	__cmdArgDesc = p_argsDescription;
}

/// @function fn_CMDControl_getCommands()
/// @return commandList: [ligthObject]
/// @desc Get the commands available with their properties and binding function
function fn_CMDControl_getCommands() {
	
	#region Command List
	
	var l_commandList = [
	
		// Header
		new objCommand("TITLE", "SHORT", "DESCRIPTION", undefined, ["ARGUMENT"], ["DESCRIPTION"]),
		
		// Help
		new objCommand("help", "h", 
			"Show all the help about commands",
			fn_CMDControl_showHelp,
			["command"],
			["It shows more details description about an specific command"]),
		
		// Version
		new objCommand("version", "v", 
			"Show the current gms2CMD version",
			fn_CMDControl_inputGetStringVersion),
		
		// Clear
		new objCommand("clear", "-",
			"Clear the current console log (it also reset the command history)",
			fn_CMDControl_clearLog),

		// Game
		new objCommand("game", "g",
			"Choose to restart or exit the game",
			fn_CMDControl_game,
			["status"],
			[ "Can take the values 'exit' or 'restart'" ]),
			
		// Fullscreen on-off
		new objCommand("fullscreen", "fs",
			"Change to fullscreen (on) or windowed mode (off)",
			fn_CMDControl_fullscreenMode,
			["activate"],
			[ "Can take the values 'on'(1) or 'off'(0)" ]),
		
	];
	
	#endregion
	
	return l_commandList
	

}


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
		
		fn_CMDControl_MsgShowError("Empty command sent");
		
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
	

	// NOTE: The below commented code is just for test and see each input word.
	//var l_tempJoinText = "";
	//for( var i = 0; i < array_length(__cmdTextPartArray); i++) {
	//	show_debug_message(__cmdTextPartArray[i])
	//	l_tempJoinText += __cmdTextPartArray[i] + " ";
	//}
	
	var l_mainCommand = __cmdTextPartArray[0],
		l_params = [];
	array_copy(l_params, 0, __cmdTextPartArray, 1, array_length(__cmdTextPartArray) - 1);

	var l_commandList = fn_CMDControl_getCommands(),
		l_commandListLength = array_length(l_commandList);
	
	for( var i = 0; i < l_commandListLength; i++ ) {
	
		if( l_commandList[i].__cmdTitle == l_mainCommand or ( l_commandList[i].__cmdShort == l_mainCommand and l_commandList[i].__cmdShort != "-" )) {
			__currentCommandExecute = l_commandList[i];
			l_commandList[i].__cmdFunc(l_params);
			return -1;
		}
		
		
	}
	
	fn_CMDControl_MsgShowError("The '" + __cmdTextPartArray[0] + "' command isn't recognized");
		
	
	
}

//----------------------------
#region Commands action list

/// @function fn_CMDControl_generalCommand_oneArgumentOnly()
/// @param gameCMD: Array<String>
/// @return void
/// @desc Used for commands that have the general error with the given parameter
function fn_CMDControl_generalCommand_oneArgumentOnly(p_gameCMD) {
	
	
	var p_argsLength = array_length(p_gameCMD);
	
	switch(p_argsLength) {
		
		// Error - need at least one argument
		case 0: {
			
			fn_CMDControl_MsgShowError( 
				fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.params_less_min, __currentCommandExecute.__cmdTitle, p_argsLength, 1, 1)
			);
			break;
			
		}
		
		// Execute game command
		case 1: {
		
			__myMethod(p_gameCMD); // Important: the function tha use this one, need to declare a __myCommand function.
			
			break;
			
		}
		
		// Error - need lest than 2 arguments
		default: {
			
			fn_CMDControl_MsgShowError(
				fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.params_more_max, __currentCommandExecute.__cmdTitle, p_argsLength, 1, 1)
			);
			
			break;
			
		}
	
	}
	
}

/// @function fn_CMDControl_clearLog()
/// @return void
/// @desc Clear the current console log (it also reset the command history)
function fn_CMDControl_clearLog() {
	__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");
	__cmdLogMsgCountCurrent = 0;
}

/// @function fn_CMDControl_inputGetStringVersion()
/// @return void
/// @desc Show in the console the current version
function fn_CMDControl_inputGetStringVersion() {
	var l_versionText = 
	@"==============================
	===  GMS2 Console Command  ===
	======  by Crios Devs  =======
	==============================
	> Version:   " + string(CMD_CURRENT_VERSION) + 
	"\n==============================" ;
	
	fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_versionText);
}

/// @function fn_CMDControl_showHelp(args)
/// @param args: Array[any]
/// @return void
/// @desc Show the help information of the given command
function fn_CMDControl_showHelp(p_args) {
	
	var p_argsLength = array_length(p_args),
		l_helpText = "==== HELP ====",
		l_cmdCommands = fn_CMDControl_getCommands(),
		l_cmdCommandsLength = array_length(l_cmdCommands);
		
	switch( p_argsLength ) {
	
		// General commands
		case 0: {
		
			for( var i = 0; i < l_cmdCommandsLength; i++ ) {
		
				var l___cmdTitle = string_upper(l_cmdCommands[i].__cmdTitle),
					l___cmdShortTitle = string_upper(l_cmdCommands[i].__cmdShort),
					l___cmdDescription = l_cmdCommands[i].__cmdDesc;
			
				l_helpText += "\n" + fn_stringAddPad(l___cmdTitle, 14) +
								fn_stringAddPad(l___cmdShortTitle, 8) +
								l___cmdDescription;
			}
	
			l_helpText += "\n===============";
	
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_helpText); 
	
	
			break;
			
		}
		
		// First level argument information
		case 1: {
			
			#region Check if the first level commandexists
			
				var l_cmdArgumentExists = false;
			
				for (var i = 0; i < l_cmdCommandsLength; i++) {
			   
				   if (l_cmdCommands[i].__cmdTitle == p_args[0] or l_cmdCommands[i].__cmdShort == p_args[0]) {
				       l_cmdArgumentExists = true;
					   break;
				   }
			   
				}
			
				// If the command doesnt exists
				if !( l_cmdArgumentExists ) {
			    
					var l_errorMsgCommandNoExists = fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.command_not_exists, p_args[0]);
					fn_CMDControl_MsgShowError(l_errorMsgCommandNoExists);
				
					return -1; // exit the function
				}
			
			#endregion 
			
			#region Show the command information
			
				var l_cmdName,
					l_cmdShort;
				

					
				// Get the command information
				for (var i = 0; i < l_cmdCommandsLength; i++) {
					l_cmdName = l_cmdCommands[i].__cmdTitle;
					l_cmdShort = l_cmdCommands[i].__cmdShort;
					
					// Go to the next iteration if isn't the command to show info
					if ( l_cmdName != p_args[0] and l_cmdShort != p_args[0] ) {
						continue;    
					}
					
					var l_cmdDesc = l_cmdCommands[i].__cmdDesc,
						l_cmdArgs = l_cmdCommands[i].__cmdArgs, // it could be undefined
						l_cmdArgsDesc = l_cmdCommands[i].__cmdArgDesc; // it could be undefined

					
					// Name
					fn_cmdArrayPushFIFO( __cmdLogArrayMsg, fn_stringAddPad(">>>",6) + l_cmdName);
					
					// Description
					fn_cmdArrayPushFIFO( __cmdLogArrayMsg, l_cmdDesc + "\n");
					
					// Arguments name and description
					
					if( is_array(l_cmdArgs) ) {
						
						// Headers
						fn_cmdArrayPushFIFO(__cmdLogArrayMsg, fn_stringAddPad(l_cmdCommands[0].__cmdArgs[0], 10)
							+ fn_stringAddPad("", 4) + l_cmdCommands[0].__cmdArgDesc[0]);
						
						// Arguments name-desc
						var l_argumentDesc = "";
						for( var j = 0; j < p_argsLength; j++ ) {
					

							l_argumentDesc += fn_stringAddPad(l_cmdArgs[j], 10) + fn_stringAddPad(" :", 4) + l_cmdArgsDesc[j] + "\n";
						}
						
						fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_argumentDesc + "\n");
						
					}
					
					
					return -1; // Exit the function
				}
				
			#endregion
			
			
			break;
			
		}
		
		// Too much arguments
		default: {
		
			fn_CMDControl_MsgShowError(fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.params_more_max, "help", p_argsLength, 0, 1) );
			return -1;
			
			break;
			
		}
	
	}

	
}

	
/// @function fn_CMDControl_game(status)
/// @param gameCMD: Array<String>
/// @return void
/// @desc Select the function to execute a game command
function fn_CMDControl_game(p_gameCMD) {

	__myMethod = function(p_gameCMD) {
	
		switch(p_gameCMD[0]) {		
			case "restart":{
				
				game_restart();
				break;
			}
			
			case "exit":{
				game_end();
				break;
			}
			
			default: {


				fn_CMDControl_MsgShowError( 
					fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.command_not_exists, __cmdTextPartArray[0] + " " + __cmdTextPartArray[1])
				);
				break;
			}
		}
	}

				
	fn_CMDControl_generalCommand_oneArgumentOnly(p_gameCMD);
	
}

/// @function fn_CMDControl_fullscreenMode(activate)
/// @param activate: Array<String> (boolean)
/// @return void
/// @desc Select the function to execute a game command
function fn_CMDControl_fullscreenMode(p_fullscreenCMD) {

	__myMethod = function(p_fullscreenCMD) {
		
		switch(p_fullscreenCMD[0]) {
			
			case "off":
			case 0: {
				
				if ( window_get_fullscreen() ) {
					
					window_set_fullscreen(false);
					//window_set_size(480, 270);
					fn_CMDTriggerResolutionChange(480, 270);
					
				} else {
					fn_CMDControl_MsgShowError("The screen is already windowed");
				}
				
				break;
			}
			
			case "on":
			case 1: {
				window_set_fullscreen(true)
				fn_CMDTriggerResolutionChange(display_get_width(), display_get_height());
				break;
			}
			
			case 2: {
				//window_set_size(960, 540);
				//fn_CMDTriggerResolutionChange(960, 540);
				//window_set_size(1366, 768);
				fn_CMDTriggerResolutionChange(1366, 768);
				break;	
			}
			
			case 3: {
				//window_set_size(480, 270);
				fn_CMDTriggerResolutionChange(480, 270);
				break;	
			}
			case 4: {
				fn_CMDTriggerResolutionChange(480,270, true);
				break;	
			}
			
			default: {
				fn_CMDControl_MsgShowError(
					fn_CMDControl_MsgGetGenericMessage(e_cmdTypeMessage.command_not_exists, __cmdTextPartArray[0] + " " + __cmdTextPartArray[1])
				);
				break;
			}
		}
				
	}

	fn_CMDControl_generalCommand_oneArgumentOnly(p_fullscreenCMD);
	
}	

#endregion

}

