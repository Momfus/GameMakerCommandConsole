///@func	fn_cmdArrayPushFIFO( array, newElement )
///@param	{Array.any}	array
///@param	{any}		newElement
///@return	{any}		oldElement
///@desc	Remove the old element and add a new one in the top
function fn_cmdArrayPushFIFO(p_array, p_elementToInsert){
	
	var l_oldElement = array_pop(p_array);
	array_insert(p_array, 0, p_elementToInsert);

	return l_oldElement;

}

///@func	fn_cmdGUICheckMouseIsHoverThisObject(stateMouseHover)
///@param	{bool}	stateMouseHover
///@return	{bool}	isHover
///@desc	Check if the mouse enter or leave the object using the gui layer
function fn_cmdGUICheckMouseIsHoverThisObject(p_stateMouseHover) {
	var l_mouseMeetingCMD = position_meeting(MOUSE_GUI_X, MOUSE_GUI_Y, id);
	
	if( p_stateMouseHover ) {
		if( !l_mouseMeetingCMD ) {
			p_stateMouseHover =  false;	
		}
	} else {
		if( l_mouseMeetingCMD ) {
			p_stateMouseHover = true
		}
	} 
	
	return p_stateMouseHover;

}

///@func	fn_cmdGetArrayStringSizeNoEmpty( array )
///@param	{Array.string}	array
///@return	{real}			arraSize
///@desc	Check for a string array size, this check to their values until there is an empty string (o no valid) value. Using this for long arrays is not recommended
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

///@func	fn_cmdInputArrayCheckPressed( arrayToCheck, arrayLength )
///@param	{Array.real}	arrayToCheck	-	It use the key codes from the GM key list
///@param	{Array.real}	arrayLength
///@return	{bool}			isAnyKeyReleased
///@desc	Check if any key in the array given was just pressed.
function fn_cmdInputArrayCheckPressed(p_arrayToCheck, p_arrayLength){
	
	for( var i = 0; i < p_arrayLength; i++ ) {
		
		if (keyboard_check_pressed( p_arrayToCheck[i] )) {
			return true;
		}
		
	}
	
	return false;

}

///@func	fn_wrapValue( valueToWrap, newElement )
///@param	{real}	valueToWrap
///@param	{real}	min
///@param	{real}	max
///@return	{real}	newValue
///@desc	Return a value wrapper between [min, max]
function fn_wrapValue(p_valueToWrap, p_min, p_max) {
	
	// Forst to be int values (with real numbers sometimes hººave wrong returns)
	p_valueToWrap = floor(p_valueToWrap);
	p_min = floor(p_min);
	p_max = floor(p_max);
	
	var l_range = p_max - p_min + 1, // "+1" is used because the "max" bound is inclusive
		l_newValue = ( ( (p_valueToWrap - p_min) mod l_range ) + l_range) mod l_range + p_min;

	
	return l_newValue;
}

///@func	fn_stringSplit(stringToSplit, delimiter, ignoreConsecutiveDelimiter)
///@param	{string}		stringToSplit
///@param	{string}		delimiter
///@param	{bool}			ignoreConsectuvieDelimite
///@return	{Array.string}	stringSplitted
///@desc	Return an string from an string with the given delimiter (example: "Hello Word" with the space delimiter " " give an two element array ["Hello", "World"]
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

///@func	fn_stringAddPad(text, spaces)
///@param	{string}	text
///@param	{real}		spaces
///@return	{string}	textWithPadding
///@desc	Return a string with a padding space if the text is smaller than the space number.
function fn_stringAddPad(p_text, p_spaces) {

	var l_padToAdd = "",
		l_textLength = string_length(p_text);
	
	for ( var i = 0; i < p_spaces - l_textLength; i++ ){
		l_padToAdd += " ";
	}
	
	return p_text + l_padToAdd;

}

///@func	fn_stringFormatTab(stringToFormat, separator)
///@param	{string}	stringArray
///@param	{string}	separator
///@return	{string}	stringFormatted
///@desc	Return the given string with a new formated with tab space (that is the number of spaces given between [..] )
function fn_stringFormatTab(p_stringToFormat, p_separator = "\\T") { // the T is important that is uppercase and two \ (GameMaker ignore the first one)

	var l_arrayStringSplit = fn_stringSplit(p_stringToFormat, p_separator, true),
		l_arrayStringSplitLength = array_length(l_arrayStringSplit),
		l_stringFormatted = "";
		
	if not( l_arrayStringSplitLength > 1 ) {
		
		l_stringFormatted = p_stringToFormat; // Just in case a text withotu special tab is used
		
	} else {
		
		#region Add spaces
		
		l_stringFormatted = l_arrayStringSplit[0];
		
		for( var i = 1; i < l_arrayStringSplitLength; i++ ) { // The text before the tag is not used because it doesnt have any format to add
			
			var l_stringRow = l_arrayStringSplit[i],
				l_posOpen = string_pos("[", l_stringRow),
				l_posClose = string_pos("]", l_stringRow),
				l_spaceNumber = real( string_copy(l_stringRow, l_posOpen + 1, l_posClose - l_posOpen + 1 ) );
			
			l_stringRow = string_delete(l_stringRow, l_posOpen, l_posClose);
			l_stringRow = fn_stringAddPad(" ", l_spaceNumber) + l_stringRow;
			
			l_stringFormatted += l_stringRow;
			
		}
	
		#endregion
	
	}
	
	return l_stringFormatted;

}

///@func	fn_stringFormatClean(stringToFormat, removeNewLine*, removeSpecialTabSpace*)
///@param	{string}	stringToFormat
///@param	{bool}		removeNewLine
///@param	{bool}		removeSpecialTabSpace
///@return	{string}	stringFormatted
///@desc	Return the given string with a new formated without the some special characters that give format specified in the parameters (like \n or \\T in this case)
function fn_stringFormatClean(p_stringToFormat, p_removeNewLine = false, p_removeSpecialTabSpace = false) {
	
	// Remove New lines
	if( p_removeNewLine ) {
		p_stringToFormat = string_replace_all(p_stringToFormat, "\n", " ");
	}
	
	#region Remove the tab space
	
	// Note: this will remove the special substring "\\T" to remove the tab space specified between the "[...]". Take note of this with the fn_stringFormatTab function (that could be differente)
	if (p_removeSpecialTabSpace) {
	    
		// String variables
		var l_specialTabStr = "\\T",
			l_stringToFormatLength = string_length(p_stringToFormat),
			l_stringAux = "";
		
		// Position variables
		var l_posCharArgOpen = undefined,
			l_posCharArgClose = undefined,
			l_posStartAux = 1; // GM use position in string from "1" (instead zero like in length)
		
		l_specialTabStr += "[";
		var l_specialTabStrArgClose = "]";
	
		while( true ) {
			
			l_posCharArgOpen = string_pos_ext(l_specialTabStr, p_stringToFormat, l_posStartAux);
			
			if( l_posCharArgOpen == 0) { // This exit the loop when there isn't more open character/substring open to find
				l_stringAux += string_copy(p_stringToFormat, l_posStartAux, l_stringToFormatLength - l_posStartAux + 1);
				break; 
			}
			
			l_posCharArgClose = string_pos_ext(l_specialTabStrArgClose, p_stringToFormat, l_posCharArgOpen) + 1;
			l_stringAux += string_copy(p_stringToFormat, l_posStartAux, l_posCharArgOpen - l_posStartAux);
			
			l_posStartAux = l_posCharArgClose;
			
		}
				
		p_stringToFormat = l_stringAux;
	}
	
	
	#endregion

	return p_stringToFormat;
}

///@func	fn_isSingleton()
///@return	{bool}	isSingleton
///@desc	Check if the object that call this function is the only one created
function fn_isSingleton() {

	var l_instNumber = instance_number(self.object_index);
	
	if(l_instNumber > 1) {
		instance_destroy();
		
		var l_objectName = object_get_name(self.object_index)
		show_debug_message("WARNING >>> Instance from object " + l_objectName + " already exists and is a singleton (id: "+ string(id) + ")" );
		
		return false;
	}
	
	return true;
	
}

