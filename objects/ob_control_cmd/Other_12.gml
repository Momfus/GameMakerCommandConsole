/// @desc Methods - Commit Input

/// @function fn_controlCMD_commitInput( commitInput )
/// @param commitInput: String
/// @return void
/// @desc Check for the input to commit
function fn_controlCMD_commitInput(p_commitInput) {

	if( p_commitInput == "" || p_commitInput == noone || p_commitInput == undefined ) {
		exit;
	}
	
	// Refresh logs arrays
	fn_cmdArrayPushFIFO(__cmdLogArrayMsg, p_commitInput);
	fn_cmdArrayPushFIFO(__cmdLogArrayInput, p_commitInput);
	
	// Send commit message to check

	
	// Clean old message input
	__cmdText[e_cmdTextInput.leftSide] = "";
	__cmdText[e_cmdTextInput.rightSide] = "";
	__cmdCursorPosition = 0;

}