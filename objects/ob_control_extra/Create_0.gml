///@desc Set Attributes

// Intrucction text
__instructionMain = "Press 'º' key to show/hide command console";

// Position
_xx = room_width * 0.5;
_yy = room_height - 50;

__instructionMainWidthHalf = string_width(__instructionMain) * 0.5;



// Test
//func	fn_myTestFunction()
function fn_cmdExtraTest() {

	fn_cmdArrayPushFIFO(ob_control_cmd._cmdLogMsgArray, "My test function from ob_control_extra");

}