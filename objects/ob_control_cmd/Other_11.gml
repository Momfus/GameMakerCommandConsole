/// @desc Methods - Keyboard

// @function fn_controlCMD_inputKeyboardUser();
// @desc Check all the inputs from keyboard that user is writing in the CMD
function fn_controlCMD_inputKeyboardUser() {
			
	if ( keyboard_check_pressed(vk_anykey)  ) {
	    
		// Check special keyboard commands before
		if ( keyboard_check(vk_enter) ) {
		
			#region Commit CMD
			
			
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
