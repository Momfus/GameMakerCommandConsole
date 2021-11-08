/// @desc Draw console

if ( __currentState == e_cmdState.opened ) {
	
	draw_set_font(ft_arial_12);

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

		draw_set_color(c_orange);
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		
		// Arrow indicator
		draw_text(__paddingInner, __posTextY, ">");
		

		
		#region Input Text
		
			var l_textLeftCursorWidth = string_width( __cmdText[e_cmdTextInput.leftSide]);
		
			// Text Left
			draw_set_color(c_white);
			draw_text(__posTextStartX, __posTextY, __cmdText[e_cmdTextInput.leftSide]);
		
			// Cursor
			draw_set_color(c_orange);
			if( __cmdCursorVisible ) {
				draw_text( __posTextStartX + l_textLeftCursorWidth, __posTextY, "|");	
			}
			
			// Test Right
			draw_set_color(c_white);
			draw_text(__posTextStartX + l_textLeftCursorWidth + string_length("|"), __posTextY, __cmdText[e_cmdTextInput.rightSide]);
			

		#endregion
		
	
	#endregion 
	

	// Reset
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	
	
	

}
