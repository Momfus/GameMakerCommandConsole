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

/// @function fn_cmdGetArrayStringSizeNoEmpty( array )
/// @param array: [string]
/// @return arraSize: int
/// @desc Check for a string array size, this check to their values until there is an empty string (o no valid) value. Using this for long arrays is not recommended
function fn_cmdGetArrayStringSizeNoEmpty(p_array){
	
	var l_arrayRealSize = array_length(p_array),
		l_elementArrayTemp = undefined;
		
	for( var i = 0; i < l_arrayRealSize; i++ ) {
		
		l_elementArrayTemp = p_array[i];
		if(l_elementArrayTemp == "" || l_elementArrayTemp == undefined || l_elementArrayTemp == noone ) {
			break;
		}
	
	}
	
	return ( ( i - 1 ) >= 0 ? i : 0); // (i - 1 ) is needed to know if the first element is already empty. 
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


//@function fn_stringSplit(stringToSplit, delimiter, ignoreConsecutiveDelimiter)
//@param stringToSplit: string
//@param delimiter: string
//@param ignoreConsectuvieDelimite: boolean
//@return stringSplitted: [string]
//@desc Return an string array from an string with the given delimiter (example: "Hello Word" with the space delimiter " " give an two element array ["Hello", "World"]
function fn_stringSplit(p_strToSplit, p_delimiter, p_ignoreEmptyString) {
	
	p_strToSplit += p_delimiter; // Add the delimiter to the end to finish the loop;
	var l_delimiterLength = string_length(p_delimiter),
		l_slotOffset = 0,
		l_pos = 0, // Loop position used with the given string
		l_stringSplittedArray = "",
		l_delimiterCount = string_count(p_delimiter, p_strToSplit),
		l_copyString = undefined; // Auxiliar string with the stringToSplit value before the delimiter
		
		for( var i = 0; i < l_delimiterCount; i++ ) {
		
			l_pos = string_pos( p_delimiter, p_strToSplit ) + (l_delimiterLength - 1); // Check for the last position with the delimiter length (-1 is used because strings are arrays starting in zero position)
			l_copyString = string_copy( p_strToSplit, 1, l_pos - l_delimiterLength );
			
			if ( l_copyString != "" || !p_ignoreEmptyString ) {
			    
				l_stringSplittedArray[i - l_slotOffset] = l_copyString; // Copy the string section to the new array
				
			} else {
			
				l_slotOffset++;
				
			}
			
			p_strToSplit = string_delete(p_strToSplit, 1, l_pos); // Delete the section that was added in the new array
		}
		
	
	return l_stringSplittedArray;
	
}