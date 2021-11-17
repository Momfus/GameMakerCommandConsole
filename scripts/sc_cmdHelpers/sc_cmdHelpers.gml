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

/// @function fn_wrapValue( valueToWrap, newElement )
/// @param valueToWrap: int
/// @param min: int
/// @param max: int
/// @return newValue: int
/// @desc Return a value wrapper between [min, max]
function fn_wrapValue(p_valueToWrap, p_min, p_max) {
	
	// Forst to be int values (with real numbers sometimes have wrong returns)
	p_valueToWrap = floor(p_valueToWrap);
	p_min = floor(p_min);
	p_max = floor(p_max);
	
	var l_range = p_max - p_min + 1, // "+1" is used because the "max" bound is inclusive
		l_newValue = ( ( (p_valueToWrap - p_min) mod l_range ) + l_range) mod l_range + p_min;

	
	return l_newValue;
}