///@desc Camera attributes

#region Methods

	///@func	_mtConsoleResizeWindow()
	///@return	void
	///@desc	Change the necesary attributes when the resolution is different.
	function _mtConsoleResizeWindow() {
	
		_cameraViewWidth = ob_control_resolution._resIdealWidth;
		_cameraViewHeight = ob_control_resolution._resIdealHeight;
	
		camera_set_view_size(MAIN_VIEW, _cameraViewWidth, _cameraViewHeight);

	}

#endregion

// Object Init
fn_isSingleton();

#macro MAIN_VIEW view_camera[0]

_objectTarget = ob_player_example;
_cameraViewWidth = 0;
_cameraViewHeight = 0;

_mtConsoleResizeWindow();

