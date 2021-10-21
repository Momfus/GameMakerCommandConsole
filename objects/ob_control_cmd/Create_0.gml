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

// Keys
#region Inputs Arrays (here you can add or remove keys to show and hide cmd)

	__cmdInputOpenKeyArray = [220, 112]; // [º, F1] keycode
	__cmdInputCloseKeyArray = [220, 112, 27] // [º, F1, Esc] 
	
	__cmdInputOpenLength = array_length(__cmdInputOpenKeyArray);
	__cmdInputCloseLength = array_length(__cmdInputCloseKeyArray);

#endregion

#region Visual Settings

	// Visual
	__alpha = 0.65;

	// Position
	__xx = 0;
	__yy = 0;
	__width = display_get_gui_width();
	__height = 200;

#endregion


// Declare methods
event_user(0); // Begin Step States
event_user(1); // Declare keyboard cmd functions

show_debug_message("[gms2-consoleCommand] You are using gms2-consoleCommand by @Momfus (Version: " + CMD_CURRENT_VERSION + ")");