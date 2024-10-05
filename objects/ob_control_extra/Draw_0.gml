///@desc Instructions

// Square background text
draw_set_color(c_black);
var l_xx1 = _xx - __instructionMainWidthHalf - 16,
	l_xx2 = _xx + __instructionMainWidthHalf + 16,
	l_yy1 = _yy - 20,
	l_yy2 = _yy + 20;
	
draw_rectangle(l_xx1, l_yy1, l_xx2, l_yy2, false );

// Text
draw_set_font(ft_console_9);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text_transformed(_xx, _yy, __instructionMain, 1, 1, 0);
