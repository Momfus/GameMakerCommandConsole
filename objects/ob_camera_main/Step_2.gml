///@desc Follow Target

if( _objectTarget != undefined and instance_exists(_objectTarget) ) {
	
	var l_x = clamp(_objectTarget.x - _cameraViewWidth * 0.5, 0, room_width - _cameraViewWidth), 
		l_y = clamp(_objectTarget.y - _cameraViewHeight * 0.5, 0, room_height - _cameraViewHeight); 
		
	//camera_set_view_pos(MAIN_VIEW, l_x, l_y); // Follow object directly		
		
	// Smoothg camera effect
	var l_camCurrentX = camera_get_view_x(MAIN_VIEW),
		l_camCurrentY = camera_get_view_y(MAIN_VIEW),
		l_camSpd = 0.1;
	
		
	camera_set_view_pos(MAIN_VIEW, lerp(l_camCurrentX, l_x, l_camSpd), lerp(l_camCurrentY, l_y, l_camSpd) );
		
}

