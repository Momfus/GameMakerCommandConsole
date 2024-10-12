///@desc Follow Target

if( _objectTarget != undefined and instance_exists(_objectTarget) ) {
	
	var xx = clamp(_objectTarget.x - _cameraViewWidth * 0.5, 0, room_width - _cameraViewWidth), 
		yy = clamp(_objectTarget.y - _cameraViewHeight * 0.5, 0, room_height - _cameraViewHeight); 
		
	//camera_set_view_pos(MAIN_VIEW, xx, yy); // Follow object directly		
		
	// Smoothg camera effect
	var camCurrentX = camera_get_view_x(MAIN_VIEW),
		camCurrentY = camera_get_view_y(MAIN_VIEW),
		camSpd = 0.1;
	
		
	camera_set_view_pos(MAIN_VIEW, lerp(camCurrentX, xx, camSpd), lerp(camCurrentY, yy, camSpd) );
		
}

