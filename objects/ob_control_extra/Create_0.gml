///@desc Set Attributes

// Intrucction text
_instructionMain = "Press 'º' key to show/hide command console";

// Position
_xx = room_width * 0.5;
_yy = room_height - 50;

_instructionMainWidthHalf = string_width(_instructionMain) * 0.5;



//<Test>

///@func	_mtCMDExtraTest()
function _mtCMDExtraTest() {

	fn_cmdArrayPushFIFO(ob_control_cmd._cmdLogMsgArray, "My test function from ob_control_extra");

}