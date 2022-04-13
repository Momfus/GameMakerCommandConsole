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
		
		var h1 = __heightLog,
			h2 = __cmdMsgWindowHeight,
			hRelative = h1/h2,
			tapH = hRelative * h1,
			tapW = 6,
			tapX = x + __width - tapW,
			tapRelativeEmptySpaceToScroll = h1 - tapH,
			tapPosOffset = (tapRelativeEmptySpaceToScroll * __cmdWindowSurfaceYoffset ) / (-__cmdMsgTop);
				
		draw_rectangle( tapX,
						tapRelativeEmptySpaceToScroll + tapPosOffset,
						tapX + tapW,
						tapRelativeEmptySpaceToScroll + tapPosOffset + tapH,
						false);
		
		draw_set_color(c_red);
		draw_line_width(0, tapRelativeEmptySpaceToScroll, room_width, tapRelativeEmptySpaceToScroll, 2);		
		
		draw_set_color(c_blue);
		draw_line_width(0, tapRelativeEmptySpaceToScroll + tapPosOffset, room_width, tapRelativeEmptySpaceToScroll +tapPosOffset, 2);		

	}
	

}