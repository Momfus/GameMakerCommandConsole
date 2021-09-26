/// @function fn_inputArrayCheckReleased( arrayToCheck, arrayLength )
/// @param arrayToCheck: [keyCode]
/// @param arrayLength: int
/// @return IsAnyKeyReleased: bool
/// @desc Check if any key in the array given was released.
function fn_inputArrayCheckReleased(p_arrayToCheck, p_arrayLength){
	
	for( var i = 0; i < p_arrayLength; i++ ) {
		
		if (keyboard_check_released( p_arrayToCheck[i] )) {
			return true;
		}
		
	}

}