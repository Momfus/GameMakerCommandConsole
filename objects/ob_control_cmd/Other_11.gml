/// @desc Methods - Keyboard

// @function fn_controlCMD_inputKeyboardUser();
// @desc Check all the inputs from keyboard that user is writing in the CMD
function fn_controlCMD_inputKeyboardUser() {
			
	if ( keyboard_check_pressed(vk_anykey)  ) {
	    
		var __cmdTextLength = string_length(__cmdText);
		// Check special keyboard commands before
		if ( __cmdKeyReleasedCommitInput ) {
		
			#region Commit CMD
			
			
			#endregion	
			
		} else if(__cmdKeyMoveCursorLeft) {
			
			#region Move cursor to the left
				__cmdCursorPosition--;
				__cmdCursorPosition = clamp(__cmdCursorPosition, 0, __cmdTextLength);
			#endregion	
			
		} else if(__cmdKeyMoveCursorRight) {
			
			#region Move cursor to the rigth
				__cmdCursorPosition++;
				__cmdCursorPosition = clamp(__cmdCursorPosition, 0, __cmdTextLength);
			#endregion	
			
		} else {
			#region Normal Keyboard inputs
			
				if ( fn_controlCMD_checkKeyboardKey() ) {
					//show_debug_message("CMD >>> Char: " + string(keyboard_lastchar) + "     >>> Key: " + string(keyboard_lastkey) );
					
					__cmdText = string_insert(keyboard_lastchar, __cmdText, __cmdCursorPosition + 1);
					__cmdCursorPosition++;
					
					show_debug_message(__cmdText)
				}
				
			#endregion
		}	
			
	}
	
	
	keyboard_clear(keyboard_key); // Reset the input keyboard state (if was pressed, released, etc) 
	
}

function fn_controlCMD_checkKeyboardKey() {
	
	return (
		(keyboard_key >= 48 && keyboard_key <= 90 ) ||
		(keyboard_key >= 96 && keyboard_key <= 111) ||
		keyboard_key >= 186 ||
		keyboard_key == 32
	)
	
}



// @function fn_controlCMD_checkSpecilKeyInput();
// @desc Check for the special keys when the CMD is open (there many of keys that are not used when is close)
function fn_controlCMD_checkSpecilKeyInput() {
	
	__cmdKeyPressedShowHide = fn_inputArrayCheckPressed( __cmdInputCloseKeyArray, __cmdInputCloseLength );
	
	__cmdKeyReleasedCommitInput = keyboard_check_released(vk_enter);
	
	__cmdKeyMoveCursorLeft = keyboard_check(vk_left);
	__cmdKeyMoveCursorRight = keyboard_check(vk_right);
	
	
}