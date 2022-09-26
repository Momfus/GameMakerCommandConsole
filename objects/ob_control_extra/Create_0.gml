/// @desc Set Attributes

// Intrucction text
__instructionMain = "Press 'º' key to show/hide command console";

// Position
__xx = room_width * 0.5;
__yy = room_height - 50;

__instructionMainWidthHalf = string_width(__instructionMain) * 0.5;



// Test
//function fn_myTestFunction() {
function fn_cmdExtraTest() {

	fn_cmdArrayPushFIFO(ob_control_cmd.__cmdLogArrayMsg, "My test function from ob_control_extra");

}