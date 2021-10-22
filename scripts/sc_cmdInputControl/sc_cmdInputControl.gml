/// @function fn_inputArrayCheckPressed( arrayToCheck, arrayLength )
/// @param arrayToCheck: [keyCode]
/// @param arrayLength: int
/// @return IsAnyKeyReleased: bool
/// @desc Check if any key in the array given was just pressed.
function fn_inputArrayCheckPressed(p_arrayToCheck, p_arrayLength){
	
	for( var i = 0; i < p_arrayLength; i++ ) {
		
		if (keyboard_check_pressed( p_arrayToCheck[i] )) {
			return true;
		}
		
	}
	
	return false;

}