/// @description Methos - GUI & Surface

/// @function fn_CMDControl_fn_windoCMD_drawElements()
/// @return void
/// @desc Draw all the elements needed in the surface for the CMD Window
function fn_CMDWindow_drawSurfce(){
	
	surface_set_target(__surfCmdWindow);
	draw_clear_alpha(c_black, 0);
	
	draw_set_font(ft_arial_12);
	draw_set_halign(fa_left);
	
	#region Background
	
		// Log background
		draw_set_color(c_black);
		draw_set_alpha(__alphaLog);
		draw_rectangle(__xx, __yy, __width, __heightLog, false)
	
		// CMD Input background
		draw_set_alpha(__alphaCmdInput)
		draw_rectangle(__xx, __posCmdInputY1, __width, __posCmdInputY2, false);
	
		draw_set_alpha(1);		
	
	#endregion
	
	#region Log text cmd
	
		draw_set_color(c_white);
		draw_set_valign(fa_bottom);
		
		var l_yyAux = 0;
		for( var i = 0; i < __cmdLogCountMax; i++ ) {
			draw_text(__posTextStartX, __heightLog - (i * 8) - l_yyAux, __cmdLogArrayMsg[i]);
			l_yyAux += string_height(__cmdLogArrayMsg[i])
		}
	
	#endregion
		
	#region Main text cmd input

		draw_set_color(c_orange);
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
	
	surface_reset_target();
	
	draw_surface(__surfCmdWindow, 0, 0);
}
