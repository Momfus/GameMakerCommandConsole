///@desc Instructions

// Square background text
draw_set_color(c_black);
var xx1 = _xx - _instructionMainWidthHalf - 16,
	xx2 = _xx + _instructionMainWidthHalf + 16,
	yy1 = _yy - 20,
	yy2 = _yy + 20;
	
draw_rectangle(xx1, yy1, xx2, yy2, false );

// Text
draw_set_font(ft_console_9);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text_transformed(_xx, _yy, _instructionMain, 1, 1, 0);
