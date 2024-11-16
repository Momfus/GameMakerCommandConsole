/// All the general functions

///@func	fn_cmdArrayPushFIFO()
///@desc	Remove the old element and add a new one in the top
///@param	{Array<Any>}	p_array
///@param	{Any}		p_elementToInsert
///@return	{Any}		oldElement
function fn_cmdArrayPushFIFO(p_array, p_elementToInsert){
	
	var oldElement = array_pop(p_array);
	array_insert(p_array, 0, p_elementToInsert);

	return oldElement;

}

///@func	fn_cmdGUICheckMouseIsHoverThisObject()
///@desc	Check if the mouse enter or leave the object using the gui layer
///@param	{bool}	p_stateMouseHover
///@return	{bool}	isHover
function fn_cmdGUICheckMouseIsHoverThisObject(p_stateMouseHover) {
	var mousePositionMeetingCMD = position_meeting(MOUSE_GUI_X, MOUSE_GUI_Y, id);
	
	if( p_stateMouseHover ) {
		if( !mousePositionMeetingCMD ) {
			p_stateMouseHover =  false;	
		}
	} else {
		if( mousePositionMeetingCMD ) {
			p_stateMouseHover = true
		}
	} 
	
	return p_stateMouseHover;

}

/**
@func	fn_cmdGetArrayStringSizeNoEmpty()
@desc	Check for a string array size, this check to their values until there is an empty string (o no valid) value. 
		Using this for long arrays is not recommended
@param	{Array<String>}	p_array
@return	{Real}			arraySize
**/
function fn_cmdGetArrayStringSizeNoEmpty(p_array){
	
	var arrayRealSize = array_length(p_array),
		elementArrayTemp = undefined;
	
	var indexToCheck; // This is setting here to check after the forLoop
	for( indexToCheck = 0; indexToCheck < arrayRealSize; indexToCheck++ ) {
		
		elementArrayTemp = p_array[indexToCheck];
		if(elementArrayTemp == "" || elementArrayTemp == undefined  ) {
			break;
		}
	
	}
	
	return ( indexToCheck > 0 ? indexToCheck : 0); // Is needed to know if the first element is already empty. 
}

///@func	fn_cmdInputArrayCheckPressed( arrayToCheck, arrayLength )
///@desc	Check if any key in the array given was just pressed.
///@param	{Array<real>}	p_arrayToCheck	-	It use the key codes from the GM key list
///@param	{Real}			p_arrayLength
///@return	{bool}			isAnyKeyReleased
function fn_cmdInputArrayCheckPressed(p_arrayToCheck, p_arrayLength){
	
	for( var i = 0; i < p_arrayLength; i++ ) {
		
		if (keyboard_check_pressed( p_arrayToCheck[i] )) {
			return true;
		}
		
	}
	
	return false;

}

///@func	fn_wrapValue( valueToWrap, newElement )
///@desc	Return a value wrapper between [min, max]
///@param	{real}	p_valueToWrap
///@param	{real}	p_min
///@param	{real}	p_max
///@return	{real}	newValue
function fn_wrapValue(p_valueToWrap, p_min, p_max) {
	
	// Forst to be int values (with real numbers sometimes hººave wrong returns)
	p_valueToWrap = floor(p_valueToWrap);
	p_min = floor(p_min);
	p_max = floor(p_max);
	
	var range = p_max - p_min + 1, // "+1" is used because the "max" bound is inclusive
		newValue = ( ( (p_valueToWrap - p_min) mod range ) + range) mod range + p_min;

	
	return newValue;
}

/**
@func	fn_stringSplit(stringToSplit, delimiter, ignoreConsecutiveDelimiter)
@desc	 Return an array of strings split from a string using the given delimiter 
		(example: "Hello World" with the space delimiter " " returns a two-element array ["Hello", "World"]).
@param	{string}		p_strToSplit
@param	{string}		p_delimiter
@param	{bool}			p_ignoreEmptyString
@return	{Array<String>}	stringSplitted
**/
function fn_stringSplit(p_strToSplit, p_delimiter, p_ignoreEmptyString) {
	
	p_strToSplit += p_delimiter; // Add the delimiter to the end to finish the loop;
	var delimiterLength = string_length(p_delimiter),
		slotOffset = 0,
		pos = 0, // Loop position used with the given string
		stringSplittedArray = "",
		delimiterCount = string_count(p_delimiter, p_strToSplit),
		copyString = undefined; // Auxiliar string with the stringToSplit value before the delimiter
		
		for( var i = 0; i < delimiterCount; i++ ) {
		
			pos = string_pos( p_delimiter, p_strToSplit ) + (delimiterLength - 1); // Check for the last position with the delimiter length (-1 is used because strings are arrays starting in zero position)
			copyString = string_copy( p_strToSplit, 1, pos - delimiterLength );
			
			if ( copyString != "" || !p_ignoreEmptyString ) {
			    
				stringSplittedArray[i - slotOffset] = copyString; // Copy the string section to the new array
				
			} else {
			
				slotOffset++;
				
			}
			
			p_strToSplit = string_delete(p_strToSplit, 1, pos); // Delete the section that was added in the new array
		}
		
	
	return stringSplittedArray;
	
}

///@func	fn_stringAddPad(text, spaces)
///@desc	Return a string with a padding space if the text is smaller than the space number.
///@param	{string}	p_text
///@param	{real}		p_spaces
///@return	{string}	textWithPadding
function fn_stringAddPad(p_text, p_spaces) {

	var padToAdd = "",
		textLength = string_length(p_text);
	
	for ( var i = 0; i < p_spaces - textLength; i++ ){
		padToAdd += " ";
	}
	
	return p_text + padToAdd;

}

///@func	fn_stringFormatTab(stringToFormat, separator)
///@desc	Return the given string with a new formated with tab space (that is the number of spaces given between [..] )
///@param	{String}	p_stringToFormat
///@param	{String}	p_separator
///@return	{String}	stringFormatted
function fn_stringFormatTab(p_stringToFormat, p_separator = "\\T") { // The T is important that is uppercase and two \ (GameMaker ignore the first one)

	var arrayStringSplit = fn_stringSplit(p_stringToFormat, p_separator, true),
		arrayStringSplitLength = array_length(arrayStringSplit),
		stringFormatted = "";
		
	if not( arrayStringSplitLength > 1 ) {
		
		stringFormatted = p_stringToFormat; // Just in case a text withotu special tab is used
		
	} else {
		
		#region Add spaces
		
		stringFormatted = arrayStringSplit[0];
		
		for( var i = 1; i < arrayStringSplitLength; i++ ) { // The text before the tag is not used because it doesnt have any format to add
			
			var stringRow = arrayStringSplit[i],
				posOpen = string_pos("[", stringRow),
				posClose = string_pos("]", stringRow),
				spaceNumber = real( string_copy(stringRow, posOpen + 1, posClose - posOpen + 1 ) );
			
			stringRow = string_delete(stringRow, posOpen, posClose);
			stringRow = fn_stringAddPad(" ", spaceNumber) + stringRow;
			
			stringFormatted += stringRow;
			
		}
	
		#endregion
	
	}
	
	return stringFormatted;

}

///@func	fn_stringFormatClean(stringToFormat, removeNewLine*, removeSpecialTabSpace*)
///@desc	Return the given string with a new formated without the some special characters that give format specified in the parameters (like \n or \\T in this case)
///@param	{String}	p_stringToFormat
///@param	{bool}		p_removeNewLine
///@param	{bool}		p_removeSpecialTabSpace
///@return	{String}	stringFormatted
function fn_stringFormatClean(p_stringToFormat, p_removeNewLine = false, p_removeSpecialTabSpace = false) {
	
	// Remove New lines
	if( p_removeNewLine ) {
		p_stringToFormat = string_replace_all(p_stringToFormat, "\n", " ");
	}
	
	#region Remove the tab space
	
	// Note: this will remove the special substring "\\T" to remove the tab space specified between the "[...]". Take note of this with the fn_stringFormatTab function (that could be differente)
	if (p_removeSpecialTabSpace) {
	    
		// String variables
		var specialTabStr = "\\T",
			stringToFormatLength = string_length(p_stringToFormat),
			stringAux = "";
		
		// Position variables
		var posCharArgOpen = undefined,
			posCharArgClose = undefined,
			posStartAux = 1; // GM use position in string from "1" (instead zero like in length)
		
		specialTabStr += "[";
		var specialTabStrArgClose = "]";
	
		while( true ) {
			
			posCharArgOpen = string_pos_ext(specialTabStr, p_stringToFormat, posStartAux);
			
			if( posCharArgOpen == 0) { // This exit the loop when there isn't more open character/substring open to find
				stringAux += string_copy(p_stringToFormat, posStartAux, stringToFormatLength - posStartAux + 1);
				break; 
			}
			
			posCharArgClose = string_pos_ext(specialTabStrArgClose, p_stringToFormat, posCharArgOpen) + 1;
			stringAux += string_copy(p_stringToFormat, posStartAux, posCharArgOpen - posStartAux);
			
			posStartAux = posCharArgClose;
			
		}
				
		p_stringToFormat = stringAux;
	}
	
	
	#endregion

	return p_stringToFormat;
}

///@func	fn_isSingleton()
///@desc	Check if the object that call this function is the only one created
///@return	{bool}	isSingleton
function fn_isSingleton() {

	var instNumber = instance_number(self.object_index);
	
	if(instNumber > 1) {
		instance_destroy();
		
		var objectName = object_get_name(self.object_index)
		show_debug_message("WARNING >>> Instance from object " + objectName + " already exists and is a singleton (id: "+ string(id) + ")" );
		
		return false;
	}
	
	return true;
	
}


///@func    fn_getCurrentFps()
///@desc	Returns the current FPS value of the game.
///@return  {real}
function fn_getCurrentFps() {
    return game_get_speed(gamespeed_fps);
}


///@func	fn_checkNormalKeyboardKey()
///@desc	Check for the normal keyboard inputs
///@return	{Bool}
function fn_checkNormalKeyboardKey() {
	
	// Feather ignore GM1044
	return (
        (keyboard_key >= 48 and keyboard_key <= 90) ||  // ASCII 0-9, A-Z
        (keyboard_key >= 96 and keyboard_key <= 111) || // Numpad 0-9
        keyboard_key >= 186 or                         // Symbols (; = [ ] \ , - . / `)
        keyboard_key == 32                             // Space key
	)
	// Feather restore GM1044

}
