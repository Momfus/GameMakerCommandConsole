/// @desc Draw on the camera

// Always set the camera after the movements of all objets.

camera_set_view_size(MAIN_VIEW, __cameraWidth, __cameraHeight);



if( __objectTarget != undefined and instance_exists(__objectTarget) ) {
	
	var l_x = clamp(__objectTarget.x - __cameraWidth * 0.5, 0, room_width - __cameraWidth), 
		l_y = clamp(__objectTarget.y - __cameraHeight * 0.5, 0, room_height - __cameraHeight); 
		
	//camera_set_view_pos(MAIN_VIEW, l_x, l_y); // Follow object directly		
		
	// Smoothg camera effect
	var l_camCurrentX = camera_get_view_x(MAIN_VIEW),
		l_camCurrentY = camera_get_view_y(MAIN_VIEW),
		l_camSpd = 0.1;
	
		
	camera_set_view_pos(MAIN_VIEW, lerp(l_camCurrentX, l_x, l_camSpd), lerp(l_camCurrentY, l_y, l_camSpd) );
		
}

