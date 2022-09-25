/// @desc Camera attributes

fn_isSingleton();

#macro MAIN_VIEW view_camera[0]

__objectTarget = ob_playerExample;
__cameraViewWidth = 0;
__cameraViewHeight = 0;

/// @function fn_resizeWindow()
/// @return void
/// @desc Change the necesary attributes when the resolution is different.
function fn_resizeWindow() {
	
	__cameraViewWidth = ob_control_resolution.__resIdealWidth;
	__cameraViewHeight = ob_control_resolution.__resIdealHeight;
	
	camera_set_view_size(MAIN_VIEW, __cameraViewWidth, __cameraViewHeight);

}


fn_resizeWindow();