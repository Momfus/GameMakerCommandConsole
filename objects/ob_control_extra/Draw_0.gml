///@desc Instructions

// Square background text
draw_set_color(c_black);
var l_xx1 = __xx - __instructionMainWidthHalf - 12,
	l_xx2 = __xx + __instructionMainWidthHalf + 12,
	l_yy1 = __yy - 20,
	l_yy2 = __yy + 20;
	
draw_rectangle(l_xx1, l_yy1, l_xx2, l_yy2, false );

// Text
draw_set_font(ft_arial_12);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(__xx, __yy, __instructionMain);
