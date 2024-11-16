///@desc Draw console

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if( ob_control_resolution._isNewWindowSizeSetted ) {

	// Console command draw
	if ( _stateCurrent == e_stateCmd.opened ) {
	
		#region Background
	
			// Log background
			draw_set_color(c_black);
			draw_set_alpha(_alphaLog);
			draw_rectangle(_xx, _yy, _widthCmd, _heightLog, false)
	
			// CMD Input background
			draw_set_alpha(_alphaCmdInput)
			draw_rectangle(_xx, _posCmdInputY1, _widthCmd, _posCmdInputY2, false);
	
			draw_set_alpha(1);		
	
		#endregion
	
		_mtCMDWindowUpdateSurface(false);
	
		draw_surface(_surfCmdWindow, _xx, _yy);
		_mtCMDWindowDrawCommandInput();
		_mtCMDWindowDrawScrollbar();

		// Reset
		draw_set_valign(fa_top);
		draw_set_alpha(1);
	
	
	}
	
}

