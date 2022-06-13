/// @desc Draw console

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if ( __currentState == e_cmdState.opened ) {
	
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
	
	if !( surface_exists(__surfCmdWindow) ) {
		__surfCmdWindow = surface_create( __width, __heightLog);
		fn_CMDWindow_updateSurface(false);
	}
	
		
	draw_surface(__surfCmdWindow, __xx, __yy);
	fn_CMDWindow_drawCommandInput();
	fn_CMDWindow_drawScrollbar();

	// Reset
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	
	
	draw_set_color(c_red);
	var l_guiWidth = display_get_gui_width(),
		l_guiHeight = display_get_gui_height();
		
	draw_rectangle(10, 10, 10 + 32, 10 + 32, false);
	draw_rectangle(l_guiWidth - 10 - 32, 10, l_guiWidth - 10, 10 + 32, false);
	draw_rectangle(10, l_guiHeight - 10 - 32, 10 + 32, l_guiHeight - 10, false);
	draw_rectangle(l_guiWidth - 10 - 32, l_guiHeight - 10 - 32, l_guiWidth - 10, l_guiHeight - 10, false);
}


