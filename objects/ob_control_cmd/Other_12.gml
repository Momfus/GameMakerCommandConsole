/// @desc Methods - Commit Input

/// @function fn_controlCMD_commitInput( commitInput )
/// @param commitInput: String
/// @return void
/// @desc Control the input to commit
function fn_controlCMD_commitInput(p_commitInput) {

	if( p_commitInput == "" || p_commitInput == noone || p_commitInput == undefined ) {
		exit;
	}
	
	// Refresh logs arrays
	fn_cmdArrayPushFIFO(__cmdLogArrayMsg, p_commitInput);
	fn_cmdArrayPushFIFO(__cmdLogArrayInput, p_commitInput);
	
	// Send commit message to check
	fn_controlCMD_getInputTextParts(p_commitInput);
	
	// Clean old message input
	__cmdText[e_cmdTextInput.leftSide] = "";
	__cmdText[e_cmdTextInput.rightSide] = "";
	__cmdCursorPosition = 0;
	
	// Reset the text part array
	//__cmdTextPartArray = undefined;
	//__cmdTextPartArray[0] = "";

}

/// @function fn_controlCMD_getInputTextParts(stringToGetParts)
/// @param stringToGetParts
/// @return textPart: [string]
/// @desc Split the input text in a string array (each word is a element) to check wich command the user want to execute
function fn_controlCMD_getInputTextParts(p_stringToGetParts) {
	
	__cmdTextPartArray = fn_stringSplit(p_stringToGetParts, " ", true);
	
	for( var i = 0; i < array_length(__cmdTextPartArray); i++) {
		show_debug_message(__cmdTextPartArray[i])
	}
	
}