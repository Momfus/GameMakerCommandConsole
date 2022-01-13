/// @description Test variable area

var l_guiHeight = display_get_gui_height(),
	l_yy = l_guiHeight - 300;

draw_set_color(c_black)
draw_rectangle(0, l_yy, 200, l_guiHeight, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(2, l_yy + 10, "__windowTop: " + string(ob_control_cmd.__windowTop) )
