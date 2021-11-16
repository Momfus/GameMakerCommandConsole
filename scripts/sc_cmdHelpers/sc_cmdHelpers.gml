/// @function fn_cmdArrayPushFIFO( array, newElement )
/// @param array: [any]
/// @param newElement: any
/// @return oldElement: any
/// @desc Remove the old element and add a new one in the top
function fn_cmdArrayPushFIFO(p_array, p_elementToInsert){
	
	var l_oldElement = array_pop(p_array);
	array_insert(p_array, 0, p_elementToInsert);

	return l_oldElement;

}

/// @function fn_cmdInputArrayCheckPressed( arrayToCheck, arrayLength )
/// @param arrayToCheck: [keyCode]
/// @param arrayLength: int
/// @return IsAnyKeyReleased: bool
/// @desc Check if any key in the array given was just pressed.
function fn_cmdInputArrayCheckPressed(p_arrayToCheck, p_arrayLength){
	
	for( var i = 0; i < p_arrayLength; i++ ) {
		
		if (keyboard_check_pressed( p_arrayToCheck[i] )) {
			return true;
		}
		
	}
	
	return false;

}