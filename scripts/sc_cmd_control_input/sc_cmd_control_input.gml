///@func sc_cmdInputControl()
///@return void
function sc_cmdInputControl() {	

/// General variables for this functions
__currentCommandExecute = undefined;


///@func	objCommand(title, shortTitle, description, useCleanDescription, function, arguments, argsDescription)
///@param	{string}		title
///@param	{string}		shortTitle
///@param	{string}		description
///@param	{bool}			[useCleanDescription]
///@param	{id.func}		[function]
///@param	{Array.string}	[arguments]
///@param	{Array.string}	[argsDescription]
///@return	{struct}		[newCommand]
///@desc	Create a command object
function objCommand(p_title, p_shortTitle, p_description, p_useCleanDescription = false, p_function = undefined, p_arguments = undefined, p_argsDescription = undefined ) constructor {
	__cmdTitle = p_title;
	__cmdShort = p_shortTitle;
	__cmdDesc = p_description;
	__cmdDescClean = (p_useCleanDescription) ? fn_stringFormatClean(p_description, true, true ): p_description;
	__cmdFunc = p_function;
	__cmdArgs = p_arguments;
	__cmdArgDesc = p_argsDescription;
}

///@func	fn_CMDControl_commandListCreate()
///@return	[struct]	commandList
///@desc	This must be call in the begining
function fn_CMDControl_commandListCreate() {
	
	#region Command List
	var l_commandList = [
	
		// Header
		new objCommand("TITLE", "SHORT", "DESCRIPTION", undefined, undefined, ["ARGUMENT"], ["DESCRIPTION"]),
		
		// Help
		new objCommand("help", "h", 
			"Show all the help about commands", undefined,
			fn_CMDControl_showHelp,
			["command"],
			["It shows more details description about an specific command"]
		),
		
		// Version
		new objCommand("version", "v", 
			"Show the current gms2CMD version", undefined,
			fn_CMDControl_inputGetStringVersion
		),
		
		// Clear
		new objCommand("clear", "-",
			"Clear the current console log (it also reset the command history)", undefined,
			fn_CMDControl_clearLog
		),

		// Game
		new objCommand("game", "g",
			"Choose to restart or exit the game", undefined,
			fn_CMDControl_game,
			["status"],
			[ "Can take the values 'exit' or 'restart'" ]
		),
			
		// Fullscreen on-off
		new objCommand("fullscreen", "fs",
			"Change to fullscreen (on) or windowed mode (off)", undefined,
			fn_CMDControl_fullscreenMode,
			["activate"],
			[ "Can take the values 'on'(1) or 'off'(0)" ]
		),
			
		// Change resolution based on an array
		new objCommand("resolution", "res",
			"Change window size or resolution GUI or test resolution information", undefined,
			fn_CMDControl_resolution,
			["subcommand", "arg1", "arg2"],
			[	"Could be... \n\\T[16]- window/w (change window size). \n\T[16]- info/i (to show or hide resolution information).\n\\T[16]- gui/g (change GUI surface resolution)", 
				"width || boolean || index for the default resolution array", 
				"height"
			]
		),
		
		// Execute scripts or object functions
		new objCommand("function", "fn",
			"Execute an object function or script", undefined,
			fn_CMDControl_functionExecute,
			["args..."],
			[	"All the arguments needed to execute the script"
			]
		),
		
	];
	
	#endregion
	
	return l_commandList;
	
}

///@func	fn_CMDControl_updateInputText(textToInsert, positionCountToAdd)
///@param	{string}	textToInsert
///@param	{real}		[positionCountToAdd]
///@return	void
///@desc	Update the text that the user is writing in the console, it will insert the text after the cursor position
function fn_CMDControl_updateInputText(l_textToInsert, l_positionCountToAdd = 1) {
	
	__cmdText[enum_cmdTextInput.leftSide] = string_insert(l_textToInsert, __cmdText[enum_cmdTextInput.leftSide], __cmdCursorPosition + 1);
	__cmdCursorPosition += l_positionCountToAdd;

					
}

///@func	fn_CMDControl_commitInput( commitInput )
///@param	{string}	commitInput
///@return	void
///@desc	Control the input to commit
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
	__cmdText[enum_cmdTextInput.leftSide] = "";
	__cmdText[enum_cmdTextInput.rightSide] = "";
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


///@func	fn_CMDControl_updateScrollbarProperties(updatePositionX, updateHeight)
///@param	{bool}	updatePositionX
///@param	{bool}	updateHeight
///@return	void
///@desc	Update the visual properties to show the scrollbar (sometimes there is no need to update the X position or the height)
function fn_CMDControl_updateScrollbarProperties (p_updatePositionX, p_updateHeight) {
		
	if( p_updatePositionX ) {
		__cmdScrollBarTapPositionX = __xx + __width - __cmdScrollBarTapWidth;
	}
	
	if( p_updateHeight ) {
		var l_heightLogOffset = __heightLog - 2,
			l_heightRelativeScrollbar = l_heightLogOffset / __cmdMsgWindowHeight;
		
		__cmdScrollBarTapHeight = clamp(l_heightRelativeScrollbar * l_heightLogOffset, __cmdScrollBarTapHeightMin, l_heightLogOffset);
		__cmdScrollBarTapRelativeEmptySpace = l_heightLogOffset - __cmdScrollBarTapHeight;
	}

	__cmdScrollBarTapPositionOffset = (__cmdScrollBarTapRelativeEmptySpace * __cmdWindowSurfaceYoffset ) / (-__cmdMsgTop);
	
}

///@func	fn_CMDControl_parseCommand()
///@return	void
///@desc	Check the command type added and resolve the input
function fn_CMDControl_parseCommand() {
	
	var l_mainCommand = string_lower(__cmdTextPartArray[0]),
		l_params = [];
	array_copy(l_params, 0, __cmdTextPartArray, 1, array_length(__cmdTextPartArray) - 1);

	for( var i = 0; i < __cmdArrayCommandsLength; i++ ) {
	
		if( __cmdArrayCommands[i].__cmdTitle == l_mainCommand or ( __cmdArrayCommands[i].__cmdShort == l_mainCommand and __cmdArrayCommands[i].__cmdShort != "-" )) {
			__currentCommandExecute = __cmdArrayCommands[i];
			__cmdArrayCommands[i].__cmdFunc(l_params);
			return -1;
		}
		
		
	}
	
	fn_CMDControl_MsgShowError("The '" + __cmdTextPartArray[0] + "' command isn't recognized");
		
	
	
}

///@func	fn_CMDControl_generalCommand_argumentControl(gameCMD, argMin, argMax)
///@param	{Array.string}	gameCMD
///@param	{real}			argMin
///@param	{real}			argMax
///@return	void
///@desc	Used for commands that have the general error with the given parameters, and minimum and maximum argument number to check
function fn_CMDControl_generalCommand_argumentControl(p_gameCMD, p_argMin, p_argMax = noone) {
	
	var p_argsLength = array_length(p_gameCMD);

	if( p_argsLength >= p_argMin and (p_argsLength <= p_argMax or p_argMax == noone ) ) {
		
		__myMethod(p_gameCMD); // Important: the function tha use this one, need to declare a __myCommand function.
		
	} else {
		
		if( p_argsLength < p_argMin ) {
			fn_CMDControl_MsgShowError(
				fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.params_less_min, __currentCommandExecute.__cmdTitle, p_argsLength, p_argMin, p_argMax)
			);
		} else {
			
			fn_CMDControl_MsgShowError(
				fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.params_more_max, __currentCommandExecute.__cmdTitle, p_argsLength, p_argMin, p_argMax)
			);
			
		}
	}

	
}

///@func	fn_CMDControl_clipboardPaste()
///@return	void
///@desc	Check if there is text in the clipboard and paste it in the cmd line (this must use when the console is open)
function fn_CMDControl_clipboardPaste() {
	
	if( clipboard_has_text() ) {
		var l_textToPaste = clipboard_get_text();
		
		l_textToPaste = string_replace_all(l_textToPaste, chr(9), "   ") // Replace the "tab spaces" for thre normal spaces.
		fn_CMDControl_updateInputText(l_textToPaste, string_length(l_textToPaste));
		
	}
	
}

// 
//----------------------------
//----------------------------
//----------------------------

#region Commands action list

///@func	fn_CMDControl_clearLog()
///@return	void
///@desc	Clear the current console log (it also reset the command history)
function fn_CMDControl_clearLog() {
	__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");
	__cmdLogMsgCountCurrent = 0;
}

///@func	fn_CMDControl_inputGetStringVersion()
///@return	void
///@desc	Show in the console the current version
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

///@func	fn_CMDControl_showHelp(args)
///@param	{Array.any}	args
///@return	void
///@desc	Show the help information of the given command
function fn_CMDControl_showHelp(p_args) {
	
	var p_argsLength = array_length(p_args),
		l_helpText = "==== HELP ====",
		
	switch( p_argsLength ) {
	
		// General commands
		case 0: {
		
			for( var i = 0; i < __cmdArrayCommandsLength; i++ ) {
		
				var l_cmdTitle = string_upper(__cmdArrayCommands[i].__cmdTitle),
					l_cmdShortTitle = string_upper(__cmdArrayCommands[i].__cmdShort),
					l_cmdDescription = __cmdArrayCommands[i].__cmdDesc;
			
				l_helpText += "\n" + fn_stringAddPad(l_cmdTitle, 14) +
								fn_stringAddPad(l_cmdShortTitle, 8) +
								l_cmdDescription;
			}
	
			l_helpText += "\n===============";
	
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, l_helpText); 
	
	
			break;
			
		}
		
		// First level argument information
		case 1: {
			
			#region Check if the first level commandexists
			
				var l_cmdArgumentExists = false;
			
				for (var i = 0; i < __cmdArrayCommandsLength; i++) {
			   
				   if (__cmdArrayCommands[i].__cmdTitle == p_args[0] or __cmdArrayCommands[i].__cmdShort == p_args[0]) {
				       l_cmdArgumentExists = true;
					   break;
				   }
			   
				}
			
				// If the command doesnt exists
				if !( l_cmdArgumentExists ) {
			    
					var l_errorMsgCommandNoExists = fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.command_not_exists, p_args[0]);
					fn_CMDControl_MsgShowError(l_errorMsgCommandNoExists);
				
					return -1; // exit the function
				}
			
			#endregion 
			
			#region Show the command information
			
				var l_cmdName,
					l_cmdShort;
				

					
				// Get the command information
				for (var i = 0; i < __cmdArrayCommandsLength; i++) {
					l_cmdName = __cmdArrayCommands[i].__cmdTitle;
					l_cmdShort = __cmdArrayCommands[i].__cmdShort;
					
					// Go to the next iteration if isn't the command to show info
					if ( l_cmdName != p_args[0] and l_cmdShort != p_args[0] ) {
						continue;    
					}
					
					var l_cmdDesc = __cmdArrayCommands[i].__cmdDescClean,
						l_cmdArgs = __cmdArrayCommands[i].__cmdArgs, // it could be undefined
						l_cmdArgsDesc = __cmdArrayCommands[i].__cmdArgDesc; // it could be undefined

					
					// Name
					fn_cmdArrayPushFIFO( __cmdLogArrayMsg, fn_stringAddPad(">>>",6) + l_cmdName);
					
					// Description
					fn_cmdArrayPushFIFO( __cmdLogArrayMsg, l_cmdDesc + "\n");
					
					// Arguments name and description
					
					if( is_array(l_cmdArgs) ) {
		
						
						// Headers
						fn_cmdArrayPushFIFO(__cmdLogArrayMsg, fn_stringAddPad(__cmdArrayCommands[0].__cmdArgs[0], 10)
							+ fn_stringAddPad("", 4) + __cmdArrayCommands[0].__cmdArgDesc[0]);
						
						// Arguments name-desc
						var l_cmdArgsLength = array_length(l_cmdArgs);

						
						var l_argumentDesc = "";
						for( var j = 0; j < l_cmdArgsLength; j++ ) {
							
							var l_formattedString  = fn_stringFormatTab(l_cmdArgsDesc[j]);
							// CHeck tab
							
							l_argumentDesc += fn_stringAddPad(l_cmdArgs[j], 10) + fn_stringAddPad(" :", 4) + l_formattedString + "\n";
							
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
		
			fn_CMDControl_MsgShowError(fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.params_more_max, "help", p_argsLength, 0, 1) );
			return -1;
			
			break;
			
		}
	
	}

	
}

	
///@func	fn_CMDControl_game(status)
///@param	{Array.string}	gameCMD
///@return	void
///@desc	Select the function to execute a game command
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
					fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.command_not_exists, __cmdTextPartArray[0] + " " + __cmdTextPartArray[1])
				);
				break;
				
			}
		}
	}

				
	fn_CMDControl_generalCommand_argumentControl(p_gameCMD, 1, 1);
	
}

///@func	fn_CMDControl_fullscreenMode(activate)
///@param	{Array.string}	activate - the string inside is a boolean or ON/OFF value or 1/0.
///@return	void
///@desc	Select the function to execute a game command
function fn_CMDControl_fullscreenMode(p_fullscreenCMD) {

	__myMethod = function(p_fullscreenCMD) {
		
		switch(p_fullscreenCMD[0]) {
			
			case "off":
			case "false":
			case 0: {
				
				if ( window_get_fullscreen() ) {
					
					window_set_fullscreen(false);
					fn_CMDTriggerResolutionChange(960, 540);
					
					fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "The programa now is windowed: 960 x 540");
					
				} else {
					fn_CMDControl_MsgShowError("The screen is already windowed");
				}
				
				break;
			}
			
			case "on":
			case "true":
			case 1: {
				
				if( window_get_fullscreen() ) {
					
					fn_CMDControl_MsgShowError("The screen is already fullscreen");
					
				} else {
					
					var l_displayWidth = display_get_width(),
						l_displayHeight = display_get_height();
					
					window_set_fullscreen(true)
					fn_CMDTriggerResolutionChange(l_displayWidth, l_displayHeight);
				
					fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "The programa now is fullscreen: " + string(l_displayWidth) + " x " + string(l_displayHeight) );
				
				}
				
				break;
				
			}
			
			default: {
				fn_CMDControl_MsgShowError(
					fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.command_not_exists, __cmdTextPartArray[0] + " " + __cmdTextPartArray[1])
				);
				break;
			}
		}
				
	}

	fn_CMDControl_generalCommand_argumentControl(p_fullscreenCMD, 1, 1);
	
}	


///@func	fn_CMDControl_resolution(argToUse)
///@param	{Array.string}	argToUse
///@return	void
///@desc	Select the function to execute a game command
function fn_CMDControl_resolution(p_argsToUse) {

	
	__myMethod = function(p_argsToUse) { 
		
		var l_firstArg = string_lower(p_argsToUse[0])
		switch(l_firstArg) {
		
			case "window":
			case "w": {
				array_delete(p_argsToUse, 0, 1);
				fn_CMDControl_resolutionSetWindowSize( p_argsToUse );
				
				break;
			}
			
			case "info":
			case "i": {
				
				var l_resShowInfo = not(ob_control_resolution.__resShowInfo),
					l_resInfoStateString = (l_resShowInfo)? "displayed" : "hidden";
					
				ob_control_resolution.__resShowInfo = l_resShowInfo;
				
				fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "Resolution information is now " + l_resInfoStateString); 
				
				
				break;
			}
			
			case "gui":
			case "g": {
				array_delete(p_argsToUse, 0, 1);
				fn_CMDControl_resolutionSetGUISize( p_argsToUse );
				break;
			}
			
			default: {
				fn_CMDControl_MsgShowError(
					fn_CMDControl_MsgGetGenericMessage(enum_cmdTypeMessage.command_not_exists, __cmdTextPartArray[0] + " " + __cmdTextPartArray[1])
				);
				break;
			}
		}
		
	}
	
	fn_CMDControl_generalCommand_argumentControl(p_argsToUse, 1, 3);


}

///@func	fn_CMDControl_resolutionSetWindowSize(argToUse)
///@param	{Array.string}	argToUse - the string inside is integer(real)
///@return	void
///@desc	Set the windows size with a width and heigth, or use an index input with the array base to test.
function fn_CMDControl_resolutionSetWindowSize(p_argsToUse) {
	
	__myMethod = function(p_argsToUse) { 
	
		var l_arrayLength = array_length(p_argsToUse);
		
		try{
			
			var l_firstNumber = real(p_argsToUse[0]);	
		
			if( l_arrayLength == 1 ) {
		
				#region Check for array index
			
				var l_windowArrayBaseLength = array_length(__cmdWindowSizeArrayBase),
				
				if( l_firstNumber >= 0 and l_firstNumber < l_windowArrayBaseLength) {
				
					var l_width = __cmdWindowSizeArrayBase[l_firstNumber][0],
						l_height = __cmdWindowSizeArrayBase[l_firstNumber][1];
					fn_CMDTriggerResolutionChange(l_width, l_height);
					fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "Window size and GUI resolution set to: " + string(l_width) + " x " + string(l_height)); 
				
				} else {
					
					// Out of rang
					fn_CMDControl_MsgShowError("The index " + string(l_firstNumber) + " is out of range.");
					
				}
			
				#endregion
		
			} else {
			
				#region Set window width and heigth
			
					var l_secondNumber = real(p_argsToUse[1]);
					
					fn_CMDTriggerResolutionChange(l_firstNumber, l_secondNumber);
					fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "Window size and GUI resolution set to: " + string(l_firstNumber) + " x " + string(l_secondNumber)); 
			
				#endregion
			
			}
		
		} catch(l_error) {
			
			show_debug_message(l_error.message);
			show_debug_message(l_error.longMessage);
			show_debug_message(l_error.script);
			show_debug_message(l_error.stacktrace);
			
			fn_CMDControl_MsgShowError(l_error.message);
		}
		

	
	}
	
	
	fn_CMDControl_generalCommand_argumentControl(p_argsToUse, 1, 2);
	
}

///@func	fn_CMDControl_resolutionSetGUISize(argToUse)
///@param	{Array.string} argToUse - the string inside is integer(real).
///@return	void
///@desc	Set the GUI size with a width and heigth.
function fn_CMDControl_resolutionSetGUISize(p_argsToUse) {
	
	__myMethod = function(p_argsToUse) { 
	
		try{
			
			var l_firstNumber = real(p_argsToUse[0]),
				l_secondNumber = real(p_argsToUse[1]);
					
			fn_CMDTriggerResolutionChange(l_firstNumber, l_secondNumber, true);
			fn_cmdArrayPushFIFO(__cmdLogArrayMsg, "GUI resolution set to: " + string(l_firstNumber) + " x " + string(l_secondNumber)); 
		
		} catch(l_error) {
			
			show_debug_message(l_error.message);
			show_debug_message(l_error.longMessage);
			show_debug_message(l_error.script);
			show_debug_message(l_error.stacktrace);
			
			fn_CMDControl_MsgShowError(l_error.message);
		}
		

	
	}
	
	
	fn_CMDControl_generalCommand_argumentControl(p_argsToUse, 2, 2);
	
}

///@func	fn_CMDControl_functionExecute(argToUse)
///@param	{Array.string}	gameCMD
///@return	void
///@desc	Execute an object function or script with the arguments needed. At least one object need to exists to execute the function.
function fn_CMDControl_functionExecute(p_gameCMD) {

	__myMethod = function(p_gameCMD) {

		
		// End test

		var l_1stArg = fn_stringSplit(p_gameCMD[0], ".", false),
			l_1stArgLength = array_length(l_1stArg);
		
		var l_objectRef = undefined,
			l_toExecute = undefined;
			
		// Check if is an object's function
		if( l_1stArgLength > 1 ) {
			
			#region Excute object function
			
			// Check for just one dot operator
			if( l_1stArgLength > 2 ) {
				fn_CMDControl_MsgShowError("Only one dot operator is allowed");
				return;
			}
			
			// Check if object exists
			l_objectRef = asset_get_index(l_1stArg[0]);
			
			if not( object_exists(l_objectRef) ) {
			
				fn_CMDControl_MsgShowError("The object '" + l_1stArg[0] + "' doesnt exists.");
				return;
			
			}
			
			
			l_toExecute =   method_get_index( variable_instance_get(l_objectRef, l_1stArg[1]) );
		
			
			// Check if the function to execute exists
			if ( l_toExecute == undefined ) {
				fn_CMDControl_MsgShowError("The script/function '" + l_1stArg[1] + "' doesnt exists in the object '" + l_1stArg[0] + "'");
				return;
			}
			
			#endregion
			
			
		} else {
			l_toExecute = asset_get_index(l_1stArg[0]);
			
			// Check if the function to execute exists
			if not( script_exists(l_toExecute) ) {
				fn_CMDControl_MsgShowError("The script/function '" + l_1stArg[0] + "' doesnt exists.");
				return;
			}
			
		}
		
		script_execute_ext(l_toExecute, p_gameCMD, 1);

		
	}

	// Parent execute first
	fn_CMDControl_generalCommand_argumentControl(p_gameCMD, 1);
	
}


#endregion

}

