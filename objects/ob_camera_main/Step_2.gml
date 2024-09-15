///@desc Follow Target

if( objectTarget != undefined and instance_exists(objectTarget) ) {
	
	var l_x = clamp(objectTarget.x - cameraViewWidth * 0.5, 0, room_width - cameraViewWidth), 
		l_y = clamp(objectTarget.y - cameraViewHeight * 0.5, 0, room_height - cameraViewHeight); 
		
	//camera_set_view_pos(MAIN_VIEW, l_x, l_y); // Follow object directly		
		
	// Smoothg camera effect
	var l_camCurrentX = camera_get_view_x(MAIN_VIEW),
		l_camCurrentY = camera_get_view_y(MAIN_VIEW),
		l_camSpd = 0.1;
	
		
	camera_set_view_pos(MAIN_VIEW, lerp(l_camCurrentX, l_x, l_camSpd), lerp(l_camCurrentY, l_y, l_camSpd) );
		
}

