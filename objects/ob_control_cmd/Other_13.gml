///@description Methods - GUI & Surface


///@func	fn_CMDWindow_updateSurface( updateMsgTop )
///@param	{bool}	updateMsgTop
///@return	void
///@desc	Draw all the elements needed in the surface for the CMD Window
function fn_CMDWindow_updateSurface(p_updateMsgeTop){
		
	if !( surface_exists(_surfCmdWindow) ) {
		_surfCmdWindow = surface_create( _width, _heightLog);
	}
	
	// Draw text on surface
	surface_set_target(_surfCmdWindow);
	draw_clear_alpha(c_black, 0);
	gpu_set_blendenable(false);
	
	draw_set_font(ft_console_9);
	draw_set_halign(fa_left);
	
	#region Log text cmd
	
		draw_set_color(c_white);
		draw_set_valign(fa_bottom);
		
		var l_yyMsgPositionAux = 0;
		
		for( var i = 0; i < _cmdLogCountMax; i++ ) 
		{
			var l_elementArrayTemp = _cmdLogMsgArray[i];
			if(l_elementArrayTemp == "") {
				continue;
			}
			
				
			draw_text_ext(	_posTextStartX, _heightLog - (i * _cmdMsgSep) - l_yyMsgPositionAux - _cmdWindowSurfaceYoffset, 
							_cmdLogMsgArray[i], -1, _width);
							
			l_yyMsgPositionAux +=  string_height_ext(_cmdLogMsgArray[i], -1, _width);	

			
		};
		
			
	#endregion

	gpu_set_blendenable(true);
	surface_reset_target();
	
	// Update cdm window propieties
	_cmdMsgWindowHeight = l_yyMsgPositionAux;
		
	if (p_updateMsgeTop) {
		_cmdMsgPositionTop =  _heightLog - ( _cmdMsgWindowHeight + (_cmdLogMsgCountCurrent * _cmdMsgSep) );
	}
		


}

///@func	fn_CMDWindow_drawCommandInput()
///@return	void
///@desc	Draw the line command input for the user
function fn_CMDWindow_drawCommandInput() {
		
	draw_set_color(c_orange);
	draw_set_valign(fa_middle);
		
	// Arrow indicator
	draw_text(_paddingInner, _posTextY, ">");
		
	#region Input Text
		
		var l_textLeftCursorWidth = string_width( _cmdTextArray[e_cmdTextInput.leftSide]);
		
		// Text Left
		draw_set_color(c_white);
		draw_text(_posTextStartX, _posTextY, _cmdTextArray[e_cmdTextInput.leftSide]);
		
		// Cursor
		draw_set_color(c_orange);
		if( _isCmdCursorVisible ) {
			draw_text( _posTextStartX + l_textLeftCursorWidth - 4 , _posTextY, "|");	
		}
			
		// Test Right
		draw_set_color(c_white);
		draw_text(_posTextStartX + l_textLeftCursorWidth + string_length("|"), _posTextY, _cmdTextArray[e_cmdTextInput.rightSide]);
			

	#endregion
		
	
	
}

///@func	fn_CMDWindow_drawScrollbar()
///@return	void
///@desc	Draw the scrollbar for the cmd window
function fn_CMDWindow_drawScrollbar() {

	if ( _cmdMsgPositionTop < 0 ) {
		
		draw_set_color(c_white);
		draw_set_alpha(1);
		

				
		draw_rectangle( _cmdScrollBarTapPositionX,
						_cmdScrollBarTapRelativeEmptySpace + _cmdScrollBarTapPositionOffset,
						_cmdScrollBarTapPositionX + _cmdScrollBarTapWidth,
						_cmdScrollBarTapRelativeEmptySpace + _cmdScrollBarTapPositionOffset + _cmdScrollBarTapHeight,
						false);

	}
	

}