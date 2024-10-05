///@desc Camera attributes

fn_isSingleton();

#macro MAIN_VIEW view_camera[0]

_objectTarget = ob_player_example;
_cameraViewWidth = 0;
_cameraViewHeight = 0;

///@func	_mtResizeWindow()
///@return	void
///@desc	Change the necesary attributes when the resolution is different.
function _mtResizeWindow() {
	
	_cameraViewWidth = ob_control_resolution.__resIdealWidth;
	_cameraViewHeight = ob_control_resolution.__resIdealHeight;
	
	camera_set_view_size(MAIN_VIEW, _cameraViewWidth, _cameraViewHeight);

}


_mtResizeWindow();