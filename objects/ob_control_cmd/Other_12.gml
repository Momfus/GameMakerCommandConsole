///@desc Methods - Commit Input

// Feather disable GM2016

/// General variables for this functions
_currentCommandExecute = undefined;


///@func	_mtObjCommand()
///@param	{String}			p_title
///@param	{String}			p_shortTitle
///@param	{String}			p_description
///@param	{bool}				[p_useCleanDescription]
///@param	{Any | Function}	[p_function]
///@param	{Array<String>}		[p_arguments]
///@param	{Array<String>}		[p_argsDescription]
///@return	{Struct}
///@desc	Create a command object
function _mtObjCommand(p_title, p_shortTitle, p_description, p_useCleanDescription = false, p_function = undefined, p_arguments = undefined, p_argsDescription = undefined ) constructor {
	_cmdTitle = p_title;
	_cmdShort = p_shortTitle;
	_cmdDesc = p_description;
	_cmdDescClean = (p_useCleanDescription) ? fn_stringFormatClean(p_description, true, true ): p_description;
	_cmdFunc = p_function;
	_cmdArgs = p_arguments;
	_cmdArgDesc = p_argsDescription;
}

///@func	_mtCommandListCreate()
///@return	{Array<Struct>}
///@desc	This must be call in the begining. It creates all the commands to use
function _mtCommandListCreate() {
	
	#region Command List
		var commandList = [
	
			// Header
			new _mtObjCommand("TITLE", "SHORT", "DESCRIPTION", undefined, undefined, ["ARGUMENT"], ["DESCRIPTION"]),
		
			// Help
			new _mtObjCommand("help", "h", 
				"Show all the help about commands", undefined,
				_mtCMDShowHelp,
				["command"],
				["It shows more details description about an specific command"]
			),
		
			// Version
			new _mtObjCommand("version", "v", 
				"Show the current gms2CMD version", undefined,
				_mtCMDInputGetStringVersion
			),
		
			// Clear
			new _mtObjCommand("clear", "-",
				"Clear the current console log (it also reset the command history)", undefined,
				_mtCMDClearLog
			),

			// Game
			new _mtObjCommand("game", "g",
				"Choose to restart or exit the game", undefined,
				_mtCMDGameControl,
				["status"],
				[ "Can take the values 'exit' or 'restart'" ]
			),
			
			// Fullscreen on-off
			new _mtObjCommand("fullscreen", "fs",
				"Change to fullscreen (on) or windowed mode (off)", undefined,
				_mtCMDFullscreenMode,
				["activate"],
				[ "Can take the values 'on'(1) or 'off'(0)" ]
			),
			
			// Change resolution based on an array
			new _mtObjCommand("resolution", "res",
				"Change window size or resolution GUI or test resolution information", undefined,
				_mtCMDResolution,
				["subcommand", "arg1", "arg2"],
				[	"Could be... \n\\T[16]- window/w (change window size). \n\T[16]- info/i (to show or hide resolution information).\n\\T[16]- gui/g (change GUI surface resolution)", 
					"width || boolean || index for the default resolution array", 
					"height"
				]
			),
		
			// Execute scripts or object functions
			new _mtObjCommand("function", "fn",
				"Execute an object function or script", undefined,
				_mtCMDFunctionExecuteControl,
				["args..."],
				[	"All the arguments needed to execute the script"
				]
			),
		
		];
	
	#endregion
	
	return commandList;
	
}

///@func	_mtUpdateInputText()
///@param	{string}	p_textToInsert
///@param	{real}		[p_positionCountToAdd]
///@return	{Undefined}
///@desc	Update the text that the user is writing in the console, it will insert the text after the cursor position
function _mtUpdateInputText(p_textToInsert, p_positionCountToAdd = 1) {

	_cmdTextArray[e_cmdTextInput.leftSide] = string_insert(p_textToInsert, _cmdTextArray[e_cmdTextInput.leftSide], _cmdCursorPosition + 1);
	_cmdCursorPosition += p_positionCountToAdd;
					
}

///@func	_mtInputCommit( p_commitInput )
///@param	{string}	p_commitInput
///@desc	Control the input to commit
function _mtInputCommit(p_commitInput) {

	if( p_commitInput == "" || p_commitInput == undefined ) {
		exit;
	}
	
		
	// Separate the input in an array command to check (ignore the spaces) and check if is valid
	_cmdTextPartArray = fn_stringSplit(p_commitInput, " ", true);
	
	if( array_length(_cmdTextPartArray) == undefined ) { 
		
		fn_cmdMsgShowError("Empty command sent");
		
	} else {
	
		fn_cmdArrayPushFIFO(_cmdLogInputArray, p_commitInput);
		_mtParseCommand();
	
	}
	
	if( _cmdLogMsgCountCurrent != _cmdLogCountMax ) {
		_cmdLogMsgCountCurrent = fn_cmdGetArrayStringSizeNoEmpty(_cmdLogMsgArray);
	}
	
	// Clean old message input
	_cmdTextArray[e_cmdTextInput.leftSide] = "";
	_cmdTextArray[e_cmdTextInput.rightSide] = "";
	_cmdCursorPosition = 0;
	
	// Reset the text part array
	_cmdTextPartArray = undefined;
	_cmdTextPartArray[0] = "";
	
	_cmdWindowSurfaceYoffset = 0; // Go to the bottom of the CMD log window
	
	_mtCMDWindowUpdateSurface(true);
	
	if( _cmdMsgPositionTop < 0 ) {
		_mtConsoleUpdateScrollbarProperties(true, true);
	}

}

///@func	_mtConsoleUpdateScrollbarProperties()
///@param	{bool}	p_updatePositionX
///@param	{bool}	p_updateHeight
///@return	{Undefined}
///@desc	Update the visual properties to show the scrollbar (sometimes there is no need to update the X position or the height)
function _mtConsoleUpdateScrollbarProperties(p_updatePositionX, p_updateHeight) {
		
	if( p_updatePositionX ) {
		_cmdScrollBarTapPositionX = _xx + _width - _cmdScrollBarTapWidth;
	}
	
	if( p_updateHeight ) {
		var heightLogOffset = _heightLog - 2,
			heightRelativeScrollbar = heightLogOffset / _cmdMsgWindowHeight;
		
		_cmdScrollBarTapHeight = clamp(heightRelativeScrollbar * heightLogOffset, _cmdScrollBarTapHeightMin, heightLogOffset);
		_cmdScrollBarTapRelativeEmptySpace = heightLogOffset - _cmdScrollBarTapHeight;
	}

	_cmdScrollBarTapPositionOffset = (_cmdScrollBarTapRelativeEmptySpace * _cmdWindowSurfaceYoffset ) / (-_cmdMsgPositionTop);
	
}

///@func	_mtParseCommand()
///@return	void
///@desc	Check the command type added and resolve the input
function _mtParseCommand() {
	
	var mainCommand = string_lower(_cmdTextPartArray[0]),
		paramsArray = [];
	array_copy(paramsArray, 0, _cmdTextPartArray, 1, array_length(_cmdTextPartArray) - 1);

	for( var i = 0; i < _cmdCommandsArrayLength; i++ ) {
	
		if( _cmdCommandsArray[i]._cmdTitle == mainCommand or ( _cmdCommandsArray[i]._cmdShort == mainCommand and _cmdCommandsArray[i]._cmdShort != "-" )) {
			_currentCommandExecute = _cmdCommandsArray[i];
			_cmdCommandsArray[i]._cmdFunc(paramsArray);
			return -1;
		}
		
	}
	
	fn_cmdMsgShowError("The '" + _cmdTextPartArray[0] + "' command isn't recognized");
	
}

///@func	_mtConsoleArgumentNumberControl(gameCMD, argMin, argMax)
///@param	{Array<String>}	p_gameCMD
///@param	{real}			p_argMin
///@param	{real}			p_argMax
///@return	void
///@desc	Used for commands that have the general error with the given parameters, and minimum and maximum argument number to check
function _mtConsoleArgumentNumberControl(p_gameCMD, p_argMin, p_argMax = undefined) {
	
	var argsLength = array_length(p_gameCMD);

	if( argsLength >= p_argMin and (argsLength <= p_argMax or p_argMax == undefined ) ) {
		
		_myMethod(p_gameCMD); // Important: the function that use this one, need to declare a __myCommand function.
		
	} else {
		
		if( argsLength < p_argMin ) {
			fn_cmdMsgShowError(
				fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.paramsLessMin, _currentCommandExecute._cmdTitle, argsLength, p_argMin, p_argMax)
			);
		} else {

			fn_cmdMsgShowError(
				fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.paramsMoreMax, _currentCommandExecute._cmdTitle, argsLength, p_argMin, p_argMax)
			);
			
		}
	}

	
}

///@func	_mtClipboardPaste()
///@return	void
///@desc	Check if there is text in the clipboard and paste it in the cmd line (this must use when the console is open)
function _mtClipboardPaste() {
	
	if( clipboard_has_text() ) {
		var textToPaste = clipboard_get_text();
		
		textToPaste = string_replace_all(textToPaste, chr(9), "   ") // Replace the "tab spaces" for thre normal spaces.
		_mtUpdateInputText(textToPaste, string_length(textToPaste));
		
	}
	
}

// 
//----------------------------
//----------------------------
//----------------------------

#region Commands action list

	///@func	_mtCMDClearLog()
	///@return	void
	///@desc	Clear the current console log (it also reset the command history)
	function _mtCMDClearLog() {
		_cmdLogMsgArray = array_create(_cmdLogCountMax, "");
		_cmdLogMsgCountCurrent = 0;
	}

	///@func	_mtCMDInputGetStringVersion()
	///@return	void
	///@desc	Show in the console the current version
	function _mtCMDInputGetStringVersion() {
		var versionText = 
		@"==============================
		===  GMS2 Console Command  ===
		======  by Crios Devs  =======
		==============================
		> Version:   " + string(CMD_CURRENT_VERSION) + 
		"\n==============================" ;
	
		fn_cmdArrayPushFIFO(_cmdLogMsgArray, versionText);
	}

	///@func	_mtCMDShowHelp(args)
	///@param	{Array<Any>}	p_argsArray
	///@desc	Show the help information of the given command
	function _mtCMDShowHelp(p_argsArray) {
	
		var argsLength = array_length(p_argsArray),
			helpText = "==== HELP ====";
		
		switch( argsLength ) {
	
			// General commands
			case 0: {
		
				for( var i = 0; i < _cmdCommandsArrayLength; i++ ) {
		
					var cmdTitle = string_upper(_cmdCommandsArray[i]._cmdTitle),
						cmdShortTitle = string_upper(_cmdCommandsArray[i]._cmdShort),
						cmdDescription = string(_cmdCommandsArray[i]._cmdDesc); //@TOFIX: _cmdDesc is always an string, but feather sometimes take it as a "any" type. Check if this is fix in the future
			
					helpText += "\n" + fn_stringAddPad(cmdTitle, 14) +
									fn_stringAddPad(cmdShortTitle, 8) +
									cmdDescription;
				}
	
				helpText += "\n===============";
	
				fn_cmdArrayPushFIFO(_cmdLogMsgArray, helpText); 
	
				break;
			
			}
		
			// First level argument information
			case 1: {
			
				#region Check if the first level command exists
			
					var cmdArgumentExists = false;
			
					for (var i = 0; i < _cmdCommandsArrayLength; i++) {
			   
					   if (_cmdCommandsArray[i]._cmdTitle == p_argsArray[0] or _cmdCommandsArray[i]._cmdShort == p_argsArray[0]) {
					       cmdArgumentExists = true;
						   break;
					   }
			   
					}
			
					// If the command doesnt exists
					if !( cmdArgumentExists ) {
			    
						var errorMsgCommandNoExists = fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.commandNotExists, p_argsArray[0]);
						fn_cmdMsgShowError(errorMsgCommandNoExists);
				
						return -1; // exit the function
					}
			
				#endregion 
			
				#region Show the command information
			
					var cmdName,
						cmdShort;
				
					// Get the command information
					for (var i = 0; i < _cmdCommandsArrayLength; i++) {
						cmdName = string(_cmdCommandsArray[i]._cmdTitle); //@TOFIX: _cmdTitle is always an string, but feather sometimes take it as a "any" type. Check if this is fix in the future
						cmdShort = _cmdCommandsArray[i]._cmdShort;
					
						// Go to the next iteration if isn't the command to show info
						if ( cmdName != p_argsArray[0] and cmdShort != p_argsArray[0] ) {
							continue;    
						}
					
						var cmdDesc = _cmdCommandsArray[i]._cmdDescClean,
							cmdArgsArray = _cmdCommandsArray[i]._cmdArgs, // it could be undefined
							cmdArgsDesc = _cmdCommandsArray[i]._cmdArgDesc; // it could be undefined

					
						// Name
						fn_cmdArrayPushFIFO( _cmdLogMsgArray, fn_stringAddPad(">>>",6) + cmdName);
					
						// Description
						fn_cmdArrayPushFIFO( _cmdLogMsgArray, cmdDesc + "\n");
					
						// Arguments name and description
					
						if( is_array(cmdArgsArray) ) {
		
						
							// Headers
							var argumentColumnName = string(_cmdCommandsArray[0]._cmdArgs[0]),
								descriptionColumnName = string(_cmdCommandsArray[0]._cmdArgDesc[0]);
							fn_cmdArrayPushFIFO(_cmdLogMsgArray, fn_stringAddPad(argumentColumnName, 10) + fn_stringAddPad("", 4) + descriptionColumnName);
						
							// Arguments name-desc
							var cmdArgsLength = array_length(cmdArgsArray);

						
							var argumentDesc = "";
							for( var j = 0; j < cmdArgsLength; j++ ) {
							
								var formattedString  = fn_stringFormatTab(cmdArgsDesc[j]);
								// CHeck tab
							
								argumentDesc += fn_stringAddPad(cmdArgsArray[j], 10) + fn_stringAddPad(" :", 4) + formattedString + "\n";
							
							}
						
							fn_cmdArrayPushFIFO(_cmdLogMsgArray, argumentDesc + "\n");
						
						}
					
					
						return -1; // Exit the function
					}
				
				#endregion
			
			
				break;
			
			}
		
			// Too much arguments
			default: {
		
				fn_cmdMsgShowError(fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.paramsMoreMax, "help", argsLength, 0, 1) );
				return -1;
			
			}
	
		}

	
	}

	
	///@func	_mtCMDGameControl(status)
	///@param	{Array<String>}	p_gameCMD
	///@desc	Select the function to execute a game command
	function _mtCMDGameControl(p_gameCMD) {

		_myMethod = function(p_gameCMD) {
	
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

					fn_cmdMsgShowError( 
						fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.commandNotExists, _cmdTextPartArray[0] + " " + _cmdTextPartArray[1])
					);
					break;
				
				}
			}
		}

				
		_mtConsoleArgumentNumberControl(p_gameCMD, 1, 1);
	
	}

	///@func	_mtCMDFullscreenMode(activate)
	///@param	{Array<String>}	p_isfullscreenCMD	The string inside is a boolean or ON/OFF value or 1/0.
	///@desc	Select the function to execute a game command
	function _mtCMDFullscreenMode(p_isfullscreenCMD) {

		_myMethod = function(p_isfullscreenCMD) {
		
			switch(p_isfullscreenCMD[0]) {
			
				case "off":
				case "false":
				case 0: {
				
					if ( window_get_fullscreen() ) {
					
						window_set_fullscreen(false);
						_mtConsoleTriggerResolutionChange(960, 540);
					
						fn_cmdArrayPushFIFO(_cmdLogMsgArray, "The programa now is windowed: 960 x 540");
					
					} else {
						fn_cmdMsgShowError("The screen is already windowed");
					}
				
					break;
				}
			
				case "on":
				case "true":
				case 1: {
				
					if( window_get_fullscreen() ) {
					
						fn_cmdMsgShowError("The screen is already fullscreen");
					
					} else {
					
						var displayWidth = display_get_width(),
							displayHeight = display_get_height();
					
						window_set_fullscreen(true)
						_mtConsoleTriggerResolutionChange(displayWidth, displayHeight);
				
						fn_cmdArrayPushFIFO(_cmdLogMsgArray, "The programa now is fullscreen: " + string(displayWidth) + " x " + string(displayHeight) );
				
					}
				
					break;
				
				}
			
				default: {
					fn_cmdMsgShowError(
						fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.commandNotExists, _cmdTextPartArray[0] + " " + _cmdTextPartArray[1])
					);
					break;
				}
			}
				
		}

		_mtConsoleArgumentNumberControl(p_isfullscreenCMD, 1, 1);
	
	}	


	///@func	_mtCMDResolution(argToUse)
	///@param	{Array<String>}	p_argsToUse
	///@return	void
	///@desc	Select the function to execute a game command
	function _mtCMDResolution(p_argsToUse) {
	
		_myMethod = function(p_argsToUse) { 
		
			var firstArgArray = string_lower(p_argsToUse[0])
			switch(firstArgArray) {
		
				case "window":
				case "w": {
					array_delete(p_argsToUse, 0, 1);
					_mtCMDResolutionSetWindowSize( p_argsToUse );
				
					break;
				}
			
				case "info":
				case "i": {
				
					var resShowInfo = not(ob_control_resolution._isResInfoShow),
						resInfoStateString = (resShowInfo)? "displayed" : "hidden";
					
					ob_control_resolution._isResInfoShow = resShowInfo;
				
					fn_cmdArrayPushFIFO(_cmdLogMsgArray, "Resolution information is now " + resInfoStateString); 
				
				
					break;
				}
			
				case "gui":
				case "g": {
					array_delete(p_argsToUse, 0, 1);
					_mtCMDResolutionSetGUISize( p_argsToUse );
					break;
				}
			
				default: {
					fn_cmdMsgShowError(
						fn_cmdMsgGetGenericMessage(e_cmdTypeMessage.commandNotExists, _cmdTextPartArray[0] + " " + _cmdTextPartArray[1])
					);
					break;
				}
			}
		
		}
	
		_mtConsoleArgumentNumberControl(p_argsToUse, 1, 3);


	}

	///@func	_mtCMDResolutionSetWindowSize(argToUse)
	///@param	{Array<String>}	p_argsToUse		The string inside must be an integer (Real)
	///@desc	Set the windows size with a width and heigth, or use an index input with the array base to test.
	function _mtCMDResolutionSetWindowSize(p_argsToUse) {
	
		_myMethod = function(p_argsToUse) { 
	
			var argsArrayLength = array_length(p_argsToUse);
		
			try {
			
				var firstNumber = real(p_argsToUse[0]);	
		
				if( argsArrayLength == 1 ) {
		
					#region Check for array index
			
					var windowArrayBaseLength = array_length(_cmdWindowSizeBaseArray);
				
					if( firstNumber >= 0 and firstNumber < windowArrayBaseLength) {
				
						var windowWidth = _cmdWindowSizeBaseArray[firstNumber][0],
							windowsHeight = _cmdWindowSizeBaseArray[firstNumber][1];
						_mtConsoleTriggerResolutionChange(windowWidth, windowsHeight);
						fn_cmdArrayPushFIFO(_cmdLogMsgArray, "Window size and GUI resolution set to: " + string(windowWidth) + " x " + string(windowsHeight)); 
				
					} else {
					
						// Out of rang
						fn_cmdMsgShowError("The index " + string(firstNumber) + " is out of range.");
					
					}
			
					#endregion
		
				} else {
			
					#region Set window width and heigth
			
						var secondNumber = real(p_argsToUse[1]);
					
						_mtConsoleTriggerResolutionChange(firstNumber, secondNumber);
						fn_cmdArrayPushFIFO(_cmdLogMsgArray, "Window size and GUI resolution set to: " + string(firstNumber) + " x " + string(secondNumber)); 
			
					#endregion
			
				}
		
			} catch(error) {
			
				// Feather disable GM2017
				show_debug_message(error.message);
				show_debug_message(error.longMessage);
				show_debug_message(error.script);
				show_debug_message(error.stacktrace);
			
				fn_cmdMsgShowError(error.message);
				// Feather enable GM2017
			}
		

	
		}
	
	
		_mtConsoleArgumentNumberControl(p_argsToUse, 1, 2);
	
	}

	///@func	_mtCMDResolutionSetGUISize(argToUse)
	///@param	{Array<String>} p_argsToUse		The string inside is integer(real).
	///@desc	Set the GUI size with a width and heigth.
	function _mtCMDResolutionSetGUISize(p_argsToUse) {
	
		_myMethod = function(p_argsToUse) { 
	
			try{
			
				var firstNumber = real(p_argsToUse[0]),
					secondNumber = real(p_argsToUse[1]);
					
				_mtConsoleTriggerResolutionChange(firstNumber, secondNumber, true);
				fn_cmdArrayPushFIFO(_cmdLogMsgArray, "GUI resolution set to: " + string(firstNumber) + " x " + string(secondNumber)); 
		
			} catch(error) {
			
				// Feather disable GM2017
				show_debug_message(error.message);
				show_debug_message(error.longMessage);
				show_debug_message(error.script);
				show_debug_message(error.stacktrace);
				fn_cmdMsgShowError(error.message);
				// Feather restore GM2017
				
			}
		

	
		}
	
	
		_mtConsoleArgumentNumberControl(p_argsToUse, 2, 2);
	
	}

	///@func	_mtCMDFunctionExecuteControl(argToUse)
	///@param	{Array<String>}	p_gameCMD
	///@desc	Execute an object function or script with the arguments needed. At least one object need to exists to execute the function.
	function _mtCMDFunctionExecuteControl(p_gameCMD) {

		_myMethod = function(p_gameCMD) {

		
			// End test

			var firstArgArray = fn_stringSplit(p_gameCMD[0], ".", false),
				firstArgArrayLength = array_length(firstArgArray);
		
			var objectRef = undefined,
				coodeToExecute = undefined;
			
			// Check if is an object's function
			if( firstArgArrayLength > 1 ) {
			
				#region Excute object function
			
				// Check for just one dot operator
				if( firstArgArrayLength > 2 ) {
					fn_cmdMsgShowError("Only one dot operator is allowed");
					return;
				}
			
				// Check if object exists
				objectRef = asset_get_index(firstArgArray[0]);
			
				if not( object_exists(objectRef) ) {
			
					fn_cmdMsgShowError("The object '" + firstArgArray[0] + "' doesnt exists.");
					return;
			
				}
			
			
				coodeToExecute =   method_get_index( variable_instance_get(objectRef, firstArgArray[1]) );
		
			
				// Check if the function to execute exists
				if ( coodeToExecute == undefined ) {
					fn_cmdMsgShowError("The script/function '" + firstArgArray[1] + "' doesnt exists in the object '" + firstArgArray[0] + "'");
					return;
				}
			
				#endregion
			
			
			} else {
				coodeToExecute = asset_get_index(firstArgArray[0]);
			
				// Check if the function to execute exists
				if not( script_exists(coodeToExecute) ) {
					fn_cmdMsgShowError("The script/function '" + firstArgArray[0] + "' doesnt exists.");
					return;
				}
			
			}
		
			script_execute_ext(coodeToExecute, p_gameCMD, 1);

		
		}

		// Parent execute first
		_mtConsoleArgumentNumberControl(p_gameCMD, 1);
	
	}


#endregion

		