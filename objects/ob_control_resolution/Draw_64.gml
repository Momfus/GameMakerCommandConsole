/// @desc Show infor

if( __resShowInfo ) {
	
	var l_xx = display_get_gui_width() - 40,
		l_yy = 24;
		
	draw_set_halign(fa_right);
	draw_text(l_xx, l_yy, "Display: " + string(__resDisplayWidth) + " x " + string(__resDisplayHeight) );
	draw_text(l_xx, l_yy + 20, "Window: " + string(window_get_width()) + " x " + string( window_get_height() ) );
	draw_text(l_xx, l_yy + 60, "GUI: " + string(display_get_gui_width()) + " x " + string(display_get_gui_height() ));
	draw_text(l_xx, l_yy + 80, "Base: " + string(__resBaseWidth) + " x " + string(__resBaseHeight ));
	draw_text(l_xx, l_yy + 100, "Aspect Ratio W/H: " + string(__resAspectRatio) );
	draw_text(l_xx, l_yy + 120, "Multiplier Offset GUI: " + string(__resGUIAspectOffset) );
	
}