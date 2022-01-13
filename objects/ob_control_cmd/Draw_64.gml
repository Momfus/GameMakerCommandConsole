/// @desc Draw console

if ( __currentState == e_cmdState.opened ) {
	
	
	if( surface_exists(__surfCmdWindow) ) {
		
		fn_CMDWindow_drawSurfce();
		
	} else {
		
		__surfCmdWindow = surface_create( __width, __posCmdInputY2);
		fn_CMDWindow_drawSurfce();
	}
	

	// Reset
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	
}
