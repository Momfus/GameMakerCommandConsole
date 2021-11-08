/// @desc Methods - Keyboard

// @function fn_controlCMD_inputKeyboardUser();
// @desc Check all the inputs from keyboard that user is writing in the CMD
function fn_controlCMD_inputKeyboardUser() {
			
	if ( keyboard_check_pressed(vk_anykey)  ) {
	    
		// Check special keyboard commands before
		if ( __cmdKeyReleasedCommitInput ) {
		
			fn_controlCMD_commitInput();
			
		} else if(__cmdKeyMoveCursorLeft) {
			
			fn_controlCMD_cursorMoveLeft(false);
			
		} else if(__cmdKeyMoveCursorRight) {
			
			fn_controlCMD_cursorMoveRigth(false);
			
		} else if(__cmdKeyBackspace) {
			
			fn_controlCMD_cursorMoveLeft(true);
			
		} else if( __cmdKeyDelete ){
			
			fn_controlCMD_cursorMoveRigth(true);
			
		} else {
			#region Normal Keyboard inputs
			
				if ( fn_controlCMD_checkKeyboardKey() ) {
					//show_debug_message("CMD >>> Char: " + string(keyboard_lastchar) + "     >>> Key: " + string(keyboard_lastkey) );
					
					__cmdText[e_cmdTextInput.leftSide] = string_insert(keyboard_lastchar, __cmdText[e_cmdTextInput.leftSide], __cmdCursorPosition + 1);
					__cmdCursorPosition++;
					
					show_debug_message("L: " + __cmdText[e_cmdTextInput.leftSide])
					show_debug_message("R: " + __cmdText[e_cmdTextInput.rightSide])
				}
				
			#endregion
		}	
			
	}
	
	
	keyboard_clear(keyboard_key); // Reset the input keyboard state (if was pressed, released, etc) 
	
}


//-------------------------------------------------

// @function fn_controlCMD_checkKeyboardKey()
// @desc Check for the normal keyboard inputs
function fn_controlCMD_checkKeyboardKey() {
	
	return (
		(keyboard_key >= 48 && keyboard_key <= 90 ) ||
		(keyboard_key >= 96 && keyboard_key <= 111) ||
		keyboard_key >= 186 ||
		keyboard_key == 32
	)
	
}

// @function fn_controlCMD_checkSpecilKeyInput()
// @desc Check for the special keys when the CMD is open (there many of keys that are not used when is close)
function fn_controlCMD_checkSpecilKeyInput() {
	
	__cmdKeyPressedShowHide = fn_inputArrayCheckPressed( __cmdInputCloseKeyArray, __cmdInputCloseLength );
	
	__cmdKeyReleasedCommitInput = keyboard_check_released(vk_enter);
	
	__cmdKeyMoveCursorLeft = keyboard_check(vk_left);
	__cmdKeyMoveCursorRight = keyboard_check(vk_right);
	
	__cmdKeyBackspace = keyboard_check(vk_backspace);
	__cmdKeyDelete = keyboard_check(vk_delete);
	
	
}

// @function fn_controlCMD_cursorMoveLeft()
// @desc Move the cursor to the left in the input string
function fn_controlCMD_cursorMoveLeft(p_deleteChar) {
	
	if (__cmdCursorPosition == 0) { exit; }
				
	var l_auxText = __cmdText[e_cmdTextInput.leftSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, __cmdCursorPosition);
				
	__cmdText[e_cmdTextInput.leftSide] = string_delete(l_auxText, __cmdCursorPosition, 1)
	__cmdText[e_cmdTextInput.rightSide] = l_charToMove + __cmdText[e_cmdTextInput.rightSide]
				
	__cmdCursorPosition--;
	
}

// @function fn_controlCMD_cursorMoveRigth()
// @desc Move the cursor to the right in the input string
function fn_controlCMD_cursorMoveRigth(p_deleteChar) {
	
	if ( __cmdText[e_cmdTextInput.rightSide] == "") { exit; }
				
	var l_auxText = __cmdText[e_cmdTextInput.rightSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, 0);
				
	__cmdText[e_cmdTextInput.leftSide] = __cmdText[e_cmdTextInput.leftSide] + l_charToMove;
	__cmdText[e_cmdTextInput.rightSide] = string_delete(l_auxText, 1, 1)
				
	if( !p_deleteChar ) {
		__cmdCursorPosition++
	};
				
}


// @function fn_controlCMD_commitInput()
// @desc Check for the input to commit
function fn_controlCMD_commitInput() {

	show_debug_message("test");

}