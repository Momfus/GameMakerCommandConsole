/// @desc Draw console

if ( __currentState == e_cmdState.opened ) {

	#region Background
	
		// History background
		draw_set_color(c_black);
		draw_set_alpha(__alphaHistory);
		draw_rectangle(__xx, __yy, __width, __heightHistory, false)
	
		// CMD Input background
		draw_set_alpha(__alphaCmdInput)
		draw_rectangle(__xx, __posCmdInputY1, __width, __posCmdInputY2, false);
	
		draw_set_alpha(1);		
	
	#endregion
	
	
	
	#region Main text cmd input
	
		var l_cmdTextInputLenght = string_width(__cmdText);
	
		draw_set_color(c_orange);
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		
		// Arrow indicator
		draw_text(__paddingInner, __posTextY, ">");
		
		// Cursor
		if( __cmdCursorVisible ) {
			var l_cursorX = __posTextStartX +  l_cmdTextInputLenght;
			draw_text(l_cursorX, __posTextY, "|");	
		}
		
		// Text
		draw_set_color(c_white);
		draw_text(__posTextStartX, __posTextY, __cmdText);
		
	
	#endregion 
	

	// Reset
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	
	
	

}
