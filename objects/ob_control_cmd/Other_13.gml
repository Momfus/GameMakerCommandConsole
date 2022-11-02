///@description Methods - GUI & Surface


///@func	fn_CMDWindow_updateSurface( updateMsgTop )
///@param	{bool}	updateMsgTop
///@return	void
///@desc	Draw all the elements needed in the surface for the CMD Window
function fn_CMDWindow_updateSurface(p_updateMsgeTop){
		
	if !( surface_exists(__surfCmdWindow) ) {
		__surfCmdWindow = surface_create( __width, __heightLog);
	}
	
	// Draw text on surface
	surface_set_target(__surfCmdWindow);
	draw_clear_alpha(c_black, 0);
	gpu_set_blendenable(false);
	
	draw_set_font(ft_console_9);
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
			
				
			draw_text_ext(	__posTextStartX, __heightLog - (i * __cmdMsgSep) - l_yyMsgPositionAux - __cmdWindowSurfaceYoffset, 
							__cmdLogArrayMsg[i], -1, __width);
							
			l_yyMsgPositionAux +=  string_height_ext(__cmdLogArrayMsg[i], -1, __width);	

			
		};
		
			
	#endregion

	gpu_set_blendenable(true);
	surface_reset_target();
	
	// Update cdm window propieties
	__cmdMsgWindowHeight = l_yyMsgPositionAux;
		
	if (p_updateMsgeTop) {
		__cmdMsgTop =  __heightLog - ( __cmdMsgWindowHeight + (__cmdLogMsgCountCurrent * __cmdMsgSep) );
	}
		


}

///@func	fn_CMDWindow_drawCommandInput()
///@return	void
///@desc	Draw the line command input for the user
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
			draw_text( __posTextStartX + l_textLeftCursorWidth - 4 , __posTextY, "|");	
		}
			
		// Test Right
		draw_set_color(c_white);
		draw_text(__posTextStartX + l_textLeftCursorWidth + string_length("|"), __posTextY, __cmdText[e_cmdTextInput.rightSide]);
			

	#endregion
		
	
	
}

///@func	fn_CMDWindow_drawScrollbar()
///@return	void
///@desc	Draw the scrollbar for the cmd window
function fn_CMDWindow_drawScrollbar() {

	if ( __cmdMsgTop < 0 ) {
		
		draw_set_color(c_white);
		draw_set_alpha(1);
		

				
		draw_rectangle( __cmdScrollBarTapPositionX,
						__cmdScrollBarTapRelativeEmptySpace + __cmdScrollBarTapPositionOffset,
						__cmdScrollBarTapPositionX + __cmdScrollBarTapWidth,
						__cmdScrollBarTapRelativeEmptySpace + __cmdScrollBarTapPositionOffset + __cmdScrollBarTapHeight,
						false);

	}
	

}