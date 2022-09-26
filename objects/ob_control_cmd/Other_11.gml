/// @desc Methods - Keyboard

/// @function fn_CMDControl_inputKeyboardUser()
/// @desc Check all the inputs from keyboard that user is writing in the CMD
function fn_CMDControl_inputKeyboardUser() {
			
	if ( keyboard_check_pressed(vk_anykey)  ) {

		// Check special keyboard commands before
		if ( __cmdKeyPressedCommitInput ) {
			
			fn_CMDControl_commitInput( __cmdText[e_cmdTextInput.leftSide] + __cmdText[e_cmdTextInput.rightSide] );
			
		} else if(__cmdKeyMoveArrowKeyLeft) {
			
			fn_CMDControl_cursorMoveLeft(false);
			
		} else if(__cmdKeyMoveArrowKeyRight) {
			
			fn_CMDControl_cursorMoveRigth(false);
			
		} else if( __cmdKeyMoveArrowKeyUp ) {
			
			fn_CMDControl_cursorMoveInputLog(__cmdKeyMoveArrowKeyUp - __cmdKeyMoveArrowKeyDown);
			
		} else if( __cmdKeyMoveArrowKeyDown ) {
			
			fn_CMDControl_cursorMoveInputLog(__cmdKeyMoveArrowKeyUp - __cmdKeyMoveArrowKeyDown);
			
		} else if(__cmdKeyBackspace) {
			
			fn_CMDControl_cursorMoveLeft(true);
			
		} else if( __cmdKeyDelete ){
			
			fn_CMDControl_cursorMoveRigth(true);
			
		} else if( __cmdKeyPaste ) {
			fn_CMDControl_clipboardPaste();
		} else {
			#region Normal Keyboard inputs
			
				if ( fn_CMDControl_checkKeyboardKey() ) {
					
					fn_CMDControl_updateInputText(keyboard_lastchar);
					
					// Reset log input history
					if( __cmdLogHistoryPosition != -1 ) {
						__cmdLogHistoryPosition	= -1;
					}
					
				}
				
			#endregion
			
		}	
			
	}
	
	
}


//-------------------------------------------------

/// @function fn_CMDControl_checkKeyboardKey()
/// @desc Check for the normal keyboard inputs
function fn_CMDControl_checkKeyboardKey() {
	
	return (
		(keyboard_key >= 48 && keyboard_key <= 90 ) ||
		(keyboard_key >= 96 && keyboard_key <= 111) ||
		keyboard_key >= 186 ||
		keyboard_key == 32
	)
	
}

/// @function fn_CMDControl_checkSpecilKeyInput()
/// @desc Check for the special keys when the CMD is open (there many of keys that are not used when is close)
function fn_CMDControl_checkSpecilKeyInput() {
	
	__cmdKeyPressedShowHide = fn_cmdInputArrayCheckPressed( __cmdInputOpenCloseKeyArray, __cmdInputOpenCloseLength );
	
	__cmdKeyPressedCommitInput = keyboard_check_pressed(vk_enter);
	
	__cmdKeyMoveArrowKeyLeft = keyboard_check(vk_left);
	__cmdKeyMoveArrowKeyRight = keyboard_check(vk_right);
	__cmdKeyMoveArrowKeyUp = keyboard_check(vk_up);
	__cmdKeyMoveArrowKeyDown = keyboard_check(vk_down);
	
	__cmdKeyBackspace = keyboard_check(vk_backspace);
	__cmdKeyDelete = keyboard_check(vk_delete);
	__cmdKeyPaste = keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("V"));
	
}

/// @function fn_CMDControl_cursorMoveLeft( deleteChar )
/// @param deleteChar : boolean
/// @desc Move the cursor to the left in the input string
function fn_CMDControl_cursorMoveLeft(p_deleteChar) {
	
	if (__cmdCursorPosition == 0) { exit; }
				
	var l_auxText = __cmdText[e_cmdTextInput.leftSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, __cmdCursorPosition);
				
	__cmdText[e_cmdTextInput.leftSide] = string_delete(l_auxText, __cmdCursorPosition, 1)
	__cmdText[e_cmdTextInput.rightSide] = l_charToMove + __cmdText[e_cmdTextInput.rightSide]
				
	__cmdCursorPosition--;
	
}

/// @function fn_CMDControl_cursorMoveRigth( deleteChar )
/// @param deleteChar : boolean
/// @desc Move the cursor to the right in the input string
function fn_CMDControl_cursorMoveRigth(p_deleteChar) {
	
	if ( __cmdText[e_cmdTextInput.rightSide] == "") { exit; }
				
	var l_auxText = __cmdText[e_cmdTextInput.rightSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, 0);
				
	__cmdText[e_cmdTextInput.leftSide] = __cmdText[e_cmdTextInput.leftSide] + l_charToMove;
	__cmdText[e_cmdTextInput.rightSide] = string_delete(l_auxText, 1, 1)
				
	if( !p_deleteChar ) {
		__cmdCursorPosition++
	};
				
}

/// @function fn_CMDControl_cursorMovInputLog( historyDirection )
/// @param historyDirection : boolean	Previo: +1; Posterior: -º
/// @desc Move the cursor to a more older input log
function fn_CMDControl_cursorMoveInputLog( p_historyDirection ) {
	
	// Check for the current input text
	if (__cmdLogHistoryPosition == -1 ) {
	    __cmdLogLastText = __cmdText[e_cmdTextInput.leftSide] + __cmdText[e_cmdTextInput.rightSide];
	}
	
	var l_logPositionNewValue = __cmdLogHistoryPosition,
		l_inputArrayNoEmptySize = fn_cmdGetArrayStringSizeNoEmpty(__cmdLogArrayInput);
	
	l_logPositionNewValue = fn_wrapValue(l_logPositionNewValue + p_historyDirection, -1, l_inputArrayNoEmptySize - 1);
	
	if( l_logPositionNewValue == -1 ) {
		
		#region Current input / Input that the user was typing
			
			__cmdText[e_cmdTextInput.leftSide] = __cmdLogLastText;
			__cmdText[e_cmdTextInput.rightSide] = "";
			__cmdCursorPosition = string_length(__cmdLogLastText);
		
		#endregion
		
	} else {
	
		#region Check for input text history
		
			var l_inputTextHistory = __cmdLogArrayInput[l_logPositionNewValue];
		
			if( l_inputTextHistory == undefined || l_inputTextHistory == "" || l_inputTextHistory == noone ) {
				exit;
			} else {
				__cmdText[e_cmdTextInput.leftSide] = l_inputTextHistory;
				__cmdText[e_cmdTextInput.rightSide] = "";
				__cmdCursorPosition = string_length(l_inputTextHistory);
			}
		
		#endregion
		
	}

	__cmdLogHistoryPosition = l_logPositionNewValue;
	
	
	
}
