/// @description Methods - GUI & Surface


/// @function fn_CMDWindow_updateSurface()
/// @return void
/// @desc Draw all the elements needed in the surface for the CMD Window
function fn_CMDWindow_updateSurface(){
	
	surface_set_target(__surfCmdWindow);
	draw_clear_alpha(c_black, 0);
	
	draw_set_font(ft_consolas_9);
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
										- l_yyMsgPositionAux - __cmdWindowSurfaceYoffset, 
						__cmdLogArrayMsg[i]);
			l_yyMsgPositionAux += string_height(__cmdLogArrayMsg[i])
		};
		
			
		__cmdMsgWindowHeight = l_yyMsgPositionAux;
		__cmdMsgTop =  __heightLog - ( __cmdMsgWindowHeight + (__cmdLogMsgCountCurrent * __cmdMsgSep) )
		
	
	#endregion
	

	surface_reset_target();

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

/// @function fn_CMDWindow_drawScrollbar()
/// @return void
/// @desc Draw the scrollbar for the cmd window
function fn_CMDWindow_drawScrollbar() {

	if ( __cmdMsgTop < 0 ) {
		
		draw_set_color(c_white);
		draw_set_alpha(1);
		
		var l_heightLogOffset = __heightLog - 1;
		
		/////////
		var l_cmdPadHeightMin = 6,
			l_cmdPadHeight = l_heightLogOffset,
			l_cmdPadWidth = 8,
			l_cmdPadHeightRelative =  l_heightLogOffset / __cmdMsgWindowHeight;
		
		l_cmdPadHeight = clamp(l_heightLogOffset * l_cmdPadHeightRelative, l_cmdPadHeightMin, l_heightLogOffset);
		
		
		//////
		var l_cmdPadX = x + __width - 6,
			l_cmdPadY = l_heightLogOffset,
			l_cmdPadRelativePosY = __cmdWindowSurfaceYoffset / __cmdMsgTop,
			l_cmdPadPosY = l_heightLogOffset - (l_cmdPadRelativePosY * l_cmdPadY);
		

		l_cmdPadPosY = clamp(l_cmdPadPosY, l_cmdPadHeight, l_heightLogOffset);

		
		//draw_text(2, 10, l_cmdPadHeightRelative);

		draw_rectangle( l_cmdPadX,
						l_cmdPadPosY - l_cmdPadHeight,
						l_cmdPadX + l_cmdPadWidth,
						l_cmdPadPosY,
						false);
		
	}
	

}