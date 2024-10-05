///@desc Camera attributes

fn_isSingleton();

#macro MAIN_VIEW view_camera[0]

objectTarget = ob_player_example;
cameraViewWidth = 0;
cameraViewHeight = 0;

///@func	fn_ResizeWindow()
///@return	void
///@desc	Change the necesary attributes when the resolution is different.
function fn_ResizeWindow() {
	
	cameraViewWidth = ob_control_resolution.__resIdealWidth;
	cameraViewHeight = ob_control_resolution.__resIdealHeight;
	
	camera_set_view_size(MAIN_VIEW, cameraViewWidth, cameraViewHeight);

}


fn_ResizeWindow();