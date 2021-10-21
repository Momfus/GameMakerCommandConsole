/// @desc Draw console

if ( __currentState == e_cmdState.opened ) {

	// Background console
	draw_set_color(c_black);
	draw_set_alpha(__alpha);
		draw_rectangle(__xx, __yy, __width, __height, false)
	draw_set_alpha(1);
	
	// Main text cmd
	draw_set_color(c_white);
	draw_set_font(ft_arial_12);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);

	// Reset
	draw_set_valign(fa_top);
	draw_set_alpha(1);

}
