///@description Methods - GUI & Surface


///@func	_mtCMDWindowUpdateSurface( updateMsgTop )
///@param	{bool}	p_updateMsgeTop
///@desc	Draw all the elements needed in the surface for the CMD Window
function _mtCMDWindowUpdateSurface(p_updateMsgeTop){
		
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
		
		var yyMsgPositionAux = 0;
		
		for( var i = 0; i < _cmdLogCountMax; i++ ) 
		{
			var elementArrayTemp = _cmdLogMsgArray[i];
			if(elementArrayTemp == "") {
				continue;
			}
			
				
			draw_text_ext(	_posTextStartX, _heightLog - (i * _cmdMsgSep) - yyMsgPositionAux - _cmdWindowSurfaceYoffset, 
							_cmdLogMsgArray[i], -1, _width);
							
			yyMsgPositionAux +=  string_height_ext(_cmdLogMsgArray[i], -1, _width);	

			
		};
		
			
	#endregion

	gpu_set_blendenable(true);
	surface_reset_target();
	
	// Update cdm window propieties
	_cmdMsgWindowHeight = yyMsgPositionAux;
		
	if (p_updateMsgeTop) {
		_cmdMsgPositionTop =  _heightLog - ( _cmdMsgWindowHeight + (_cmdLogMsgCountCurrent * _cmdMsgSep) );
	}
		


}

///@func	_mtCMDWindowDrawCommandInput()
///@desc	Draw the line command input for the user
function _mtCMDWindowDrawCommandInput() {
		
	draw_set_color(c_orange);
	draw_set_valign(fa_middle);
		
	// Arrow indicator
	draw_text(_paddingInner, _posTextY, ">");
		
	#region Input Text
		
		var textLeftCursorWidth = string_width( _cmdTextArray[e_cmdTextInput.leftSide]);
		
		// Text Left
		draw_set_color(c_white);
		draw_text(_posTextStartX, _posTextY, _cmdTextArray[e_cmdTextInput.leftSide]);
		
		// Cursor
		draw_set_color(c_orange);
		if( _isCmdCursorVisible ) {
			draw_text( _posTextStartX + textLeftCursorWidth - 4 , _posTextY, "|");	
		}
			
		// Test Right
		draw_set_color(c_white);
		draw_text(_posTextStartX + textLeftCursorWidth + string_length("|"), _posTextY, _cmdTextArray[e_cmdTextInput.rightSide]);
			

	#endregion
	
}

///@func	_mtCMDWindowDrawScrollbar()
///@return	void
///@desc	Draw the scrollbar for the cmd window
function _mtCMDWindowDrawScrollbar() {

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