/// @description Methods - GUI & Surface
/// @function fn_CMDWindow_drawSurfaceMsg()
/// @return void
/// @desc Draw all the elements needed in the surface for the CMD Window
function fn_CMDWindow_drawSurfaceMsg(){
	
	surface_set_target(__surfCmdWindow);
	draw_clear_alpha(c_black, 0);
	
	draw_set_font(ft_arial_12);
	draw_set_halign(fa_left);
	
	#region Log text cmd
	
		draw_set_color(c_white);
		draw_set_valign(fa_bottom);
		
		var l_yyMsgPositionAux = 0;
		
		for( var i = 0; i < __cmdLogCountMax; i++ ) 
		{
			var l_elementArrayTemp = __cmdLogArrayMsg[i];
			if(l_elementArrayTemp == "") {
				continue;
			}
			
			draw_text(__posTextStartX, __heightLog - (i * __cmdMsgSep) 
										- l_yyMsgPositionAux - __cmdWindowsScrollPosition, 
						__cmdLogArrayMsg[i]);
			l_yyMsgPositionAux += string_height(__cmdLogArrayMsg[i])
		};
		
			
		__cmdMsgHeight = l_yyMsgPositionAux;
		__cmdMsgTop =  __heightLog - ( __cmdMsgHeight + (__cmdLogMsgCountCurrent * __cmdMsgSep) )
		
	
		draw_set_color(c_red);
		draw_line_width(__xx, __heightLog, __width,__heightLog, 2 )
		draw_line_width(__xx, __cmdMsgTop, __width,__cmdMsgTop, 2 )
	
	#endregion
	

	surface_reset_target();

	draw_surface(__surfCmdWindow, __xx, __yy);
}

/// @function fn_CMDWindow_drawCommandInput()
/// @return void
/// @desc Draw the line command input for the user
function fn_CMDWindow_drawCommandInput() {
		
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
		
	
	
}