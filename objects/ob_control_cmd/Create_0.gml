///@desc Attributes


#macro CMD_CURRENT_VERSION "0.7.3"

// This was intended to be used only on PC, so I'm aiming for a single mouse/touch device
#macro MOUSE_GUI_X  device_mouse_x_to_gui(0)
#macro MOUSE_GUI_Y  device_mouse_y_to_gui(0)


fn_isSingleton(); 



#region Declare methods

	#region In event user
	
		// Is separate in events to be more organized
		event_user(0); // Begin Step States
		event_user(1); // Declare keyboard cmd functions
		event_user(2); // Commit cmd functions
		event_user(3); // GUI and Surface functions
		event_user(4); // Declare mouse and scrollbar functions
		
	#endregion

	///@func	_mtResizeWindow()
	///@param	{real}	p_guiOffsetMultiplier
	///@return	void
	///@desc	Change the necesary attributes when the resolution is different.
	function _mtResizeWindow(p_guiOffsetMultiplier) {
	
		// Visual
		_width	*= p_guiOffsetMultiplier;
		if( _width > window_get_width() ) {
			_width = window_get_width();
		}
	
		// Mouse collision
		image_xscale *= p_guiOffsetMultiplier;
		fn_CMDControl_updateScrollbarProperties(true, true);
	
	}

	///@func _mtCmdTriggerResolutionChange()
	///@param {real}	p_windowWidth
	///@param {real}	p_windowHeight
	///@param {bool}	[p_isOnlyResizeGUI]
	///@return void
	///@desc Use this function to trigget differents action when the user change the resolution by CMD (or fullscreen)
	function _mtCmdTriggerResolutionChange(p_windowWidth, p_windowHeight, p_isOnlyResizeGUI = false) {

		if ( p_isOnlyResizeGUI ) {
			ob_control_resolution._mtControlResolutionResizeGUI(p_windowWidth, p_windowHeight)
		} else {
			ob_control_resolution._mtControlResolutionResizeAll(false, p_windowWidth, p_windowHeight);
		}

	}

#endregion

#region States

	enum e_stateCmd {

		opened,
		closed

	}

	_stateCurrent = e_stateCmd.closed;
	_stateCurrentBeginStep = undefined;

	global._gCmdOpen = false; // Not tottally necesary, but is more quickly to use.

#endregion

#region Text Attributes

	enum e_cmdTextInput {

		leftSide,
		rightSide,
	
	}

	_cmdTextArray[e_cmdTextInput.leftSide] = "";
	_cmdTextArray[e_cmdTextInput.rightSide] = "";


	_cmdCursorPosition = 0; // Where the text is focus

	_cmdTextPartArray[0] = ""; // This is use to check each string inside an input commited

#endregion

#region Log input

	_cmdLogCountMax = 50;
	_cmdLogHistoryPosition = -1; // Used to quick access the input log text with the arrow keys (up and down)
	
	_cmdLogLastText = ""; // Used to save the old value when user check log input text
	
	_cmdLogMsgCountCurrent = 0;
	
	// FIFO list to check Log cmd inputs
	_cmdLogInputArray = array_create(_cmdLogCountMax, "");
	_cmdLogMsgArray = array_create(_cmdLogCountMax, "");

	
#endregion 


#region Visual Settings

	_surfCmdWindow = undefined;
	
	// Visual
	_alphaLog = 0.5;
	_alphaCmdInput = _alphaLog + 0.4;
	
	_cmdMsgWindowHeight = 0;
	_cmdMsgPositionTop = 0;
	_cmdMsgSep = 8;

	// Padding
	_paddingInner = 10;
	
	// Height and Width
	_width = display_get_gui_width();
	_heightLog = 200;
	_heightCmdInput = 40;
	
	// Position
	_xx = 0;
	_yy = 0;
	
	_posCmdInputY1 = _heightLog;
	_posCmdInputY2 = _posCmdInputY1 + _heightCmdInput;
	
	_posTextY = _posCmdInputY1 + floor( (_posCmdInputY2 - _posCmdInputY1) * 0.5);
	_posTextStartX = _xx + _paddingInner + 16;
	
	// Cursor flash
	_timeCmdCursorFlash = 20;
	_isCmdCursorVisible = true;
	alarm[0] = _timeCmdCursorFlash;

#endregion

#region Mouse variables

	// Set collision mask that trigger witht mouse events 
	image_xscale = _width;
	image_yscale = _posCmdInputY1;

	_isCmdMouseHover = false;
	_isCmdMouseWheelUp = false;
	_isCmdMouseWheelDown = false;
	
	// Scroll
	_cmdScrollSpeed = 40;
	_cmdWindowSurfaceYoffset = 0;
	
	// scrollbar tap
	_cmdScrollBarTapHeight = 0;
	_cmdScrollBarTapHeightMin = 4;
	_cmdScrollBarTapWidth = 6;
	
	_cmdScrollBarTapPositionX = 0;
	_cmdScrollBarTapRelativeEmptySpace =  0;
	_cmdScrollBarTapPositionOffset = 0;

#endregion


// Keys - Inputs Arrays (here you can add or remove keys to show and hide cmd)
_cmdInputOpenCloseKeyArray = [220, 112, 27] // Windows LATAM: [º, F1, Esc] 
_cmdInputOpenCloseArrayLength = array_length(_cmdInputOpenCloseKeyArray);

// Others

_cmdWindowSizeBaseArray = [ // used to test windows size to use with the ob_control_resolution

	[960, 540], // base
	[1024, 768],
	[1280, 540]
	
];


_cmdCommandsArray = fn_CMDControl_commandListCreate(); // Use the CMD to call functions and parse them
_cmdCommandsArrayLength = array_length(_cmdCommandsArray);

_stateCurrentBeginStep = _mtStateBeginStepCMDClosed;


show_debug_message("[GMCC] You are using GameMaker Command Console by @Momfus (Version: " + CMD_CURRENT_VERSION + ")");
