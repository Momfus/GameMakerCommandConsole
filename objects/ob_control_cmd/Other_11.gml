///@desc Methods - Keyboard

// Feather disable GM2016

///@func	_mtCMDInputKeyboardUser()
///@desc	Check all the inputs from keyboard that user is writing in the CMD
function _mtCMDInputKeyboardUser() 
{
			
	if ( keyboard_check_pressed(vk_anykey)  ) {

		// Check special keyboard commands before
		if ( _cmdKeyPressedCommitInput ) { // Commit
			
			_mtInputCommit( _cmdTextArray[e_cmdTextInput.leftSide] + _cmdTextArray[e_cmdTextInput.rightSide] );
			
		} else if(_cmdKeyMoveArrowKeyLeft) { // Move
			
			_mtConsoleCursorMoveLeft(false);
			
		} else if(_cmdKeyMoveArrowKeyRight) { // Move
			
			_mtConsoleCursorMoveRigth(false);
			
		} else if( _cmdKeyMoveArrowKeyUp ) { // Log history
			
			// Feather disable once GM1009  // This is for the below boolean operation
			_mtConsoleCursorMoveInputLog(_cmdKeyMoveArrowKeyUp - _cmdKeyMoveArrowKeyDown); //@TODO: Verificar si sigue el error de feather
			
		} else if( _cmdKeyMoveArrowKeyDown ) { // Log history
			// Feather disable once GM1009 // This is for the below boolean operation
			_mtConsoleCursorMoveInputLog(_cmdKeyMoveArrowKeyUp - _cmdKeyMoveArrowKeyDown); //@TODO: Verificar si sigue el error de feather
			
		} else if(_cmdKeyBackspace) { // Move
			
			_mtConsoleCursorMoveLeft(true);
			
		} else if( _cmdKeyDelete ){ // Delete
			
			_mtConsoleCursorMoveRigth(true);
			
		} else if( _cmdKeyPaste ) { // Paste
			
			_mtClipboardPaste();
			
		} else {
			#region Normal Keyboard inputs
			
				if ( fn_checkNormalKeyboardKey() ) {
					
					_mtUpdateInputText(keyboard_lastchar);
					
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


///@func	_mtInputCheckSpecialKey()
///@desc	Check for the special keys when the CMD is open (there many of keys that are not used when is close)
function _mtInputCheckSpecialKey() {
	

	_cmdKeyPressedShowHide = fn_cmdInputArrayCheckPressed( _cmdInputOpenCloseKeyArray, _cmdInputOpenCloseArrayLength );
	
	_cmdKeyPressedCommitInput = keyboard_check_pressed(vk_enter);
	
	_cmdKeyMoveArrowKeyLeft = keyboard_check(vk_left);
	_cmdKeyMoveArrowKeyRight = keyboard_check(vk_right);
	_cmdKeyMoveArrowKeyUp = keyboard_check(vk_up);
	_cmdKeyMoveArrowKeyDown = keyboard_check(vk_down);
	
	_cmdKeyBackspace = keyboard_check(vk_backspace);
	_cmdKeyDelete = keyboard_check(vk_delete);
	_cmdKeyPaste = keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("V"));
	
}

///@func	_mtConsoleCursorMoveLeft()
///@param	{Bool}	p_deleteChar
///@desc	Move the cursor to the left in the input string
function _mtConsoleCursorMoveLeft(p_deleteChar) {
	
	if (_cmdCursorPosition == 0) { exit; }
				
	var auxText = _cmdTextArray[e_cmdTextInput.leftSide],
		charToMove = p_deleteChar ? "" : string_char_at(auxText, _cmdCursorPosition);
				
	_cmdTextArray[e_cmdTextInput.leftSide] = string_delete(auxText, _cmdCursorPosition, 1)
	_cmdTextArray[e_cmdTextInput.rightSide] = charToMove + _cmdTextArray[e_cmdTextInput.rightSide]
				
	_cmdCursorPosition--;
	
}

///@func	_mtConsoleCursorMoveRigth( deleteChar )
///@param	{Bool}	p_deleteChar
///@desc	Move the cursor to the right in the input string
function _mtConsoleCursorMoveRigth(p_deleteChar) {
	
	if ( _cmdTextArray[e_cmdTextInput.rightSide] == "") { exit; }
				
	var auxText = _cmdTextArray[e_cmdTextInput.rightSide],
		charToMove = p_deleteChar ? "" : string_char_at(auxText, 0);
				
	_cmdTextArray[e_cmdTextInput.leftSide] = _cmdTextArray[e_cmdTextInput.leftSide] + charToMove;
	_cmdTextArray[e_cmdTextInput.rightSide] = string_delete(auxText, 1, 1)
				
	if( !p_deleteChar ) {
		_cmdCursorPosition++
	};
				
}

///@func	_mtConsoleCursorMoveInputLog( historyDirection )
///@param	{Real}	p_historyDirection	Previo: +1; Posterior: -1
///@desc	Move the cursor to a more older input log
function _mtConsoleCursorMoveInputLog( p_historyDirection ) {
	
	// Check for the current input text
	if (_cmdLogHistoryPosition == -1 ) {
	    _cmdLogLastText = _cmdTextArray[e_cmdTextInput.leftSide] + _cmdTextArray[e_cmdTextInput.rightSide];
	}
	
	var logPositionNewValue = _cmdLogHistoryPosition,
		inputArrayNoEmptySize = fn_cmdGetArrayStringSizeNoEmpty(_cmdLogInputArray);
	
	logPositionNewValue = fn_wrapValue(logPositionNewValue + p_historyDirection, -1, inputArrayNoEmptySize - 1);
	
	if( logPositionNewValue == -1 ) {
		
		#region Current input / Input that the user was typing
			
			_cmdTextArray[e_cmdTextInput.leftSide] = _cmdLogLastText;
			_cmdTextArray[e_cmdTextInput.rightSide] = "";
			_cmdCursorPosition = string_length(_cmdLogLastText);
		
		#endregion
		
	} else {
	
		#region Check for input text history
		
			var inputTextHistory = _cmdLogInputArray[logPositionNewValue];
		
			if( inputTextHistory == undefined || inputTextHistory == "" ) {
				exit;
			} else {
				_cmdTextArray[e_cmdTextInput.leftSide] = inputTextHistory;
				_cmdTextArray[e_cmdTextInput.rightSide] = "";
				_cmdCursorPosition = string_length(inputTextHistory);
			}
		
		#endregion
		
	}

	_cmdLogHistoryPosition = logPositionNewValue;
	
}