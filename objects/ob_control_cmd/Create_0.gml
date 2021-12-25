/// @desc Attributes

#macro CMD_CURRENT_VERSION "0.1.0"

// States
enum e_cmdState {

	opened,
	closed

}

__currentState = e_cmdState.closed;
__currentState_beginStep = undefined;

// Text Attributes
enum e_cmdTextInput {

	leftSide,
	rightSide,
	
}

__cmdText[e_cmdTextInput.leftSide] = "";
__cmdText[e_cmdTextInput.rightSide] = "";


__cmdCursorPosition = 0; // Where the text is focus

#region Command types and checkers

	enum e_command {
	
		cmd,
		game,
		help,
		versionLong,
		versionShort,
		scr,
		destroy,
		create,
		clear

	}

	__cmdCommand[e_command.cmd] = "cmd";
	__cmdCommand[e_command.game] = "game";
	__cmdCommand[e_command.help] = "help";
	__cmdCommand[e_command.versionLong] = "version";
	__cmdCommand[e_command.versionShort] = "v";
	__cmdCommand[e_command.scr] = "scr";
	__cmdCommand[e_command.destroy] = "destroy";
	__cmdCommand[e_command.create] = "create";
	__cmdCommand[e_command.clear] = "clear";

	__cmdTextPartArray[0] = ""; // This is use to check each string inside an input commited

#endregion


#region Log input

	__cmdLogCountMax = 10;
	__cmdLogHistoryPosition = -1; // Used to quick access the input log text with the arrow keys (up and down)
	
	__cmdLogLastText = ""; // Used to save the old value when user check log input text
	
	// FIFO list to check Log cmd inputs
	__cmdLogArrayInput = array_create(__cmdLogCountMax, "");
	__cmdLogArrayMsg = array_create(__cmdLogCountMax, "");

	
#endregion 

// Keys - Inputs Arrays (here you can add or remove keys to show and hide cmd)

__cmdInputOpenCloseKeyArray = [220, 112, 27] // [º, F1, Esc] 
__cmdInputOpenCloseLength = array_length(__cmdInputOpenCloseKeyArray);

#region Visual Settings

	
	// Visual
	__alphaLog = 0.4;
	__alphaCmdInput = __alphaLog + 0.4;

	// Padding
	__paddingInner = 10;
	
	// Height and Width
	__width = display_get_gui_width();
	__heightLog = 150;
	__heightCmdInput = 40;
	
	// Position
	__xx = 0;
	__yy = 0;
	
	__posCmdInputY1 = __heightLog;
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
event_user(2); // Commit cmd functions

// Set states
__currentState_beginStep = StateBeginStep_closed;

show_debug_message("[gms2-consoleCommand] You are using gms2-consoleCommand by @Momfus (Version: " + CMD_CURRENT_VERSION + ")");
