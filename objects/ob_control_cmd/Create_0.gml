/// @desc Attributes


#macro CMD_CURRENT_VERSION "0.7.0"

// This was intended to be used only on PC, so I'm aiming for a single mouse/touch device
#macro MOUSE_GUI_X  device_mouse_x_to_gui(0)
#macro MOUSE_GUI_Y  device_mouse_y_to_gui(0)


fn_isSingleton(); 

// States
enum e_cmdState {

	opened,
	closed

}

__currentState = e_cmdState.closed;
__currentState_beginStep = undefined;

global.gCMDOpen = false; // Not tottally necesary, but is more quickly to use.


// Text Attributes
enum e_cmdTextInput {

	leftSide,
	rightSide,
	
}

__cmdText[e_cmdTextInput.leftSide] = "";
__cmdText[e_cmdTextInput.rightSide] = "";


__cmdCursorPosition = 0; // Where the text is focus

__cmdTextPartArray[0] = ""; // This is use to check each string inside an input commited


#region Log input

	__cmdLogCountMax = 50;
	__cmdLogHistoryPosition = -1; // Used to quick access the input log text with the arrow keys (up and down)
	
	__cmdLogLastText = ""; // Used to save the old value when user check log input text
	
	__cmdLogMsgCountCurrent = 0;
	
	// FIFO list to check Log cmd inputs
	__cmdLogArrayInput = array_create(__cmdLogCountMax, "");
	__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");

	
#endregion 

// Keys - Inputs Arrays (here you can add or remove keys to show and hide cmd)

__cmdInputOpenCloseKeyArray = [220, 112, 27] // [º, F1, Esc] 
__cmdInputOpenCloseLength = array_length(__cmdInputOpenCloseKeyArray);


#region Visual Settings

	__surfCmdWindow = noone;
	
	// Visual
	__alphaLog = 0.5;
	__alphaCmdInput = __alphaLog + 0.4;
	
	
	__cmdMsgWindowHeight = 0;
	__cmdMsgTop = 0;
	__cmdMsgSep = 8;

	// Padding
	__paddingInner = 10;
	
	// Height and Width
	__width = display_get_gui_width();
	__heightLog = 200;
	__heightCmdInput = 40;
	
	// Position
	__xx = 0;
	__yy = 0;
	
	__posCmdInputY1 = __heightLog;
	__posCmdInputY2 = __posCmdInputY1 + __heightCmdInput;
	
	__posTextY = __posCmdInputY1 + floor( (__posCmdInputY2 - __posCmdInputY1) * 0.5);
	__posTextStartX = __xx + __paddingInner + 16;
	
	// Cursor flash
	__cmdCursorFlashTime = 20;
	__cmdCursorVisible = true;
	alarm[0] = __cmdCursorFlashTime;

#endregion

#region Mouse variables

	// Set collision mask that trigger witht mouse events 
	image_xscale = __width;
	image_yscale = __posCmdInputY1;

	__cmdMouseHover = false;
	__cmdMouseWheelUp = false;
	__cmdMouseWheelDown = false;
	
	
	// Scroll
	__cmdScrollSpeed = 40;
	__cmdWindowSurfaceYoffset = 0;
	
	// scrollbar tap
	__cmdScrollBarTapHeight = 0;
	__cmdScrollBarTapHeightMin = 4;
	__cmdScrollBarTapWidth = 6;
	
	__cmdScrollBarTapPositionX = 0;
	__cmdScrollBarTapRelativeEmptySpace =  0;
	__cmdScrollBarTapPositionOffset = 0;

#endregion


// Others

__cmdWindowSizeArrayBase = [ // used to test windows size to use with the ob_control_resolution

	[960, 540], // base
	[1024, 768],
	[1280, 540]
	
];


// Declare methods
event_user(0); // Begin Step States
event_user(1); // Declare keyboard cmd functions
event_user(2); // Commit cmd functions
event_user(3); // GUI and Surface functions
event_user(4); // Declare mouse and scrollbar functions




// Set states
__currentState_beginStep = StateBeginStep_closed;

show_debug_message("[gms2-consoleCommand] You are using gms2-consoleCommand by @Momfus (Version: " + CMD_CURRENT_VERSION + ")");


sc_cmdInputControl();

/// @function fn_resizeWindow(guiOffsetMultiplier)
/// @param guiOffsetMultiplier: real
/// @return void
/// @desc Change the necesary attributes when the resolution is different.
function fn_resizeWindow(p_guiOffsetMultiplier) {
	
	// Visual
	__width	*= p_guiOffsetMultiplier;
	if( __width > window_get_width() ) {
		__width = window_get_width();
	}
	
	// Mouse collision
	
	image_xscale *= p_guiOffsetMultiplier;
	fn_CMDControl_updateScrollbarProperties(true, true);
	
}

/// @function fn_CMDTriggerResolutionChange()
/// @param windowWidth : int
/// @param windowHeight : int
/// @param isOnlyResizeGUI : boolean
/// @return void
/// @desc Use this function to trigget differents action when the user change the resolution by CMD (or fullscreen)
function fn_CMDTriggerResolutionChange(p_windowWidth, p_windowHeight, p_isOnlyResizeGUI = false) {

	if ( p_isOnlyResizeGUI ) {
		ob_control_resolution.fn_controlResolutionResizeGUI(p_windowWidth, p_windowHeight)
	} else {
		ob_control_resolution.fn_controlResolutionResizeAll(false, p_windowWidth, p_windowHeight);
	}

}
	
