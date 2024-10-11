///@desc Methods - Keyboard

///@func	fn_CMDControl_inputKeyboardUser()
///@desc	Check all the inputs from keyboard that user is writing in the CMD
function fn_CMDControl_inputKeyboardUser() {
			
	if ( keyboard_check_pressed(vk_anykey)  ) {

		// Check special keyboard commands before
		if ( __cmdKeyPressedCommitInput ) {
			
			fn_CMDControl_commitInput( _cmdTextArray[e_cmdTextInput.leftSide] + _cmdTextArray[e_cmdTextInput.rightSide] );
			
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
					if( _cmdLogHistoryPosition != -1 ) {
						_cmdLogHistoryPosition	= -1;
					}
					
				}
				
			#endregion
			
		}	
			
	}
	
	
}


//-------------------------------------------------

///@func	fn_CMDControl_checkKeyboardKey()
///@desc	Check for the normal keyboard inputs
function fn_CMDControl_checkKeyboardKey() {
	
	return (
		(keyboard_key >= 48 && keyboard_key <= 90 ) ||
		(keyboard_key >= 96 && keyboard_key <= 111) ||
		keyboard_key >= 186 ||
		keyboard_key == 32
	)
	
}

///@func	fn_CMDControl_checkSpecilKeyInput()
///@desc	Check for the special keys when the CMD is open (there many of keys that are not used when is close)
function fn_CMDControl_checkSpecilKeyInput() {
	
	_cmdKeyPressedShowHide = fn_cmdInputArrayCheckPressed( _cmdInputOpenCloseKeyArray, _cmdInputOpenCloseArrayLength );
	
	__cmdKeyPressedCommitInput = keyboard_check_pressed(vk_enter);
	
	__cmdKeyMoveArrowKeyLeft = keyboard_check(vk_left);
	__cmdKeyMoveArrowKeyRight = keyboard_check(vk_right);
	__cmdKeyMoveArrowKeyUp = keyboard_check(vk_up);
	__cmdKeyMoveArrowKeyDown = keyboard_check(vk_down);
	
	__cmdKeyBackspace = keyboard_check(vk_backspace);
	__cmdKeyDelete = keyboard_check(vk_delete);
	__cmdKeyPaste = keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("V"));
	
}

///@func	fn_CMDControl_cursorMoveLeft( deleteChar )
///@param	{bool}	deleteChar
///@desc	Move the cursor to the left in the input string
function fn_CMDControl_cursorMoveLeft(p_deleteChar) {
	
	if (_cmdCursorPosition == 0) { exit; }
				
	var l_auxText = _cmdTextArray[e_cmdTextInput.leftSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, _cmdCursorPosition);
				
	_cmdTextArray[e_cmdTextInput.leftSide] = string_delete(l_auxText, _cmdCursorPosition, 1)
	_cmdTextArray[e_cmdTextInput.rightSide] = l_charToMove + _cmdTextArray[e_cmdTextInput.rightSide]
				
	_cmdCursorPosition--;
	
}

///@func	fn_CMDControl_cursorMoveRigth( deleteChar )
///@param	{bool}	deleteChar
///@desc	Move the cursor to the right in the input string
function fn_CMDControl_cursorMoveRigth(p_deleteChar) {
	
	if ( _cmdTextArray[e_cmdTextInput.rightSide] == "") { exit; }
				
	var l_auxText = _cmdTextArray[e_cmdTextInput.rightSide],
		l_charToMove = p_deleteChar ? "" : string_char_at(l_auxText, 0);
				
	_cmdTextArray[e_cmdTextInput.leftSide] = _cmdTextArray[e_cmdTextInput.leftSide] + l_charToMove;
	_cmdTextArray[e_cmdTextInput.rightSide] = string_delete(l_auxText, 1, 1)
				
	if( !p_deleteChar ) {
		_cmdCursorPosition++
	};
				
}

///@func	fn_CMDControl_cursorMovInputLog( historyDirection )
///@param	{real}	historyDirection - Previo: +1; Posterior: -1
///@desc	Move the cursor to a more older input log
function fn_CMDControl_cursorMoveInputLog( p_historyDirection ) {
	
	// Check for the current input text
	if (_cmdLogHistoryPosition == -1 ) {
	    _cmdLogLastText = _cmdTextArray[e_cmdTextInput.leftSide] + _cmdTextArray[e_cmdTextInput.rightSide];
	}
	
	var l_logPositionNewValue = _cmdLogHistoryPosition,
		l_inputArrayNoEmptySize = fn_cmdGetArrayStringSizeNoEmpty(_cmdLogInputArray);
	
	l_logPositionNewValue = fn_wrapValue(l_logPositionNewValue + p_historyDirection, -1, l_inputArrayNoEmptySize - 1);
	
	if( l_logPositionNewValue == -1 ) {
		
		#region Current input / Input that the user was typing
			
			_cmdTextArray[e_cmdTextInput.leftSide] = _cmdLogLastText;
			_cmdTextArray[e_cmdTextInput.rightSide] = "";
			_cmdCursorPosition = string_length(_cmdLogLastText);
		
		#endregion
		
	} else {
	
		#region Check for input text history
		
			var l_inputTextHistory = _cmdLogInputArray[l_logPositionNewValue];
		
			if( l_inputTextHistory == undefined || l_inputTextHistory == "" || l_inputTextHistory == noone ) {
				exit;
			} else {
				_cmdTextArray[e_cmdTextInput.leftSide] = l_inputTextHistory;
				_cmdTextArray[e_cmdTextInput.rightSide] = "";
				_cmdCursorPosition = string_length(l_inputTextHistory);
			}
		
		#endregion
		
	}

	_cmdLogHistoryPosition = l_logPositionNewValue;
	
	
	
}
