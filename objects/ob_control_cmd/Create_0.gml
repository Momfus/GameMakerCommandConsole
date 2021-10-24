/// @desc Attributes

#macro CMD_CURRENT_VERSION "0.1.0"

// States
enum e_cmdState {

	opened,
	closed

}

__currentState = e_cmdState.closed;
__currentState_beginStep = undefined;
__currentState_step = undefined;


// Text Attributes
__cmdText = "";
__cmdCursorPosition = 0; // Where the text is focus


// Keys
#region Inputs Arrays (here you can add or remove keys to show and hide cmd)

	__cmdInputOpenKeyArray = [220, 112]; // [º, F1] keycode
	__cmdInputCloseKeyArray = [220, 112, 27] // [º, F1, Esc] 
	
	__cmdInputOpenLength = array_length(__cmdInputOpenKeyArray);
	__cmdInputCloseLength = array_length(__cmdInputCloseKeyArray);
	
	#region Special Keys Inputs
	
		__cmdKeyPressedShowHide = false;
		__cmdKeyMoveCursorLeft = false;
		__cmdKeyMoveCursorRight = false;
	
	#endregion

#endregion

#region Visual Settings

	
	// Visual
	__alphaHistory = 0.4;
	__alphaCmdInput = __alphaHistory + 0.4;

	// Padding
	__paddingInner = 10;
	
	// Height and Width
	__width = display_get_gui_width();
	__heightHistory = 150;
	__heightCmdInput = 40;
	
	// Position
	__xx = 0;
	__yy = 0;
	
	__posCmdInputY1 = __heightHistory;
	__posCmdInputY2 = __posCmdInputY1 + __heightCmdInput;
	
	__posTextY = __posCmdInputY1 + floor( (__posCmdInputY2 - __posCmdInputY1) * 0.5);
	__posTextStartX = __xx + __paddingInner + 12;
	
	// Cursor flash
	__cmdCursorFlashTime = 20;
	__cmdCursorVisible = true;
	alarm[0] = __cmdCursorFlashTime;

#endregion


// Declare methods
event_user(0); // Begin Step States
event_user(1); // Declare keyboard cmd functions

// Set states
__currentState_beginStep = StateBeginStep_closed;

show_debug_message("[gms2-consoleCommand] You are using gms2-consoleCommand by @Momfus (Version: " + CMD_CURRENT_VERSION + ")");
