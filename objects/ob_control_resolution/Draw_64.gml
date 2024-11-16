///@desc Show info

if(_isNewWindowSizeSetted and _isResInfoShow ) {
	
	var xx = display_get_gui_width() - 40,
		yy = 24;
		
	draw_set_halign(fa_right);
	draw_text(xx, yy,		"Display: " + string(_resDisplayWidth) + " x " + string(_resDisplayHeight) );
	draw_text(xx, yy + 20,	"Window: " + string(window_get_width()) + " x " + string( window_get_height() ) );
	draw_text(xx, yy + 40,	"App Surface: " + string(surface_get_width(application_surface)) + " x " + string( surface_get_height(application_surface) ) );
	draw_text(xx, yy + 60,	"GUI: " + string(display_get_gui_width()) + " x " + string(display_get_gui_height() ));
	draw_text(xx, yy + 80,	"Base: " + string(_resBaseWidth) + " x " + string(_resBaseHeight ));
	draw_text(xx, yy + 100, "Aspect Ratio W/H: " + string(_resAspectRatio) );
	draw_text(xx, yy + 120, "Multiplier Offset GUI: " + string(_resGUIAspectOffset) );
	
}