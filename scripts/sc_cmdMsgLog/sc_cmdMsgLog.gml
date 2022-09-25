
enum e_cmdTypeMessage {

	params_less_min,
	params_more_max,
	command_not_exists

}

/// @function fn_CMDControl_MsgShowError(errorMsg, objectArrayMsgOwned*)
/// @param message: string
/// @param objectArrayMsgOwned*: object|instance
/// @return erroMsg: String
/// @desc Show the error msg
function fn_CMDControl_MsgShowError(p_message, p_objectArrayMsgOwned = undefined ) {

	var l_arrayTouse = p_objectArrayMsgOwned ? p_objectArrayMsgOwned.__cmdLogArrayMsg : __cmdLogArrayMsg;
		
	fn_cmdArrayPushFIFO(l_arrayTouse, "[ERROR] " + p_message);
		

	
}


/// @function fn_CMDControl_MsgGetGenericMessage(type, command, paramTotalGiven, minParams, maxParams)
/// @param type: e_cmdTypeMessage
/// @param command: string
/// @param paramTotalGiven: int
/// @param minParams: int
/// @param maxParams: int
/// @return message: String
/// @desc Get the correct message generic message with the given type
function fn_CMDControl_MsgGetGenericMessage( p_type, p_command, p_paramTotalGiven = 0, p_minParams = 0, p_maxParams = 0 ) {
	
	switch( p_type ) {
		
		case e_cmdTypeMessage.command_not_exists: {
			
			return "The \"" + p_command + "\" command isn't recognized";
			break;
		}
		
		case e_cmdTypeMessage.params_less_min: {
			
			return "\"" + p_command + "\" need at least " + string(p_minParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
			break;
		}
		
		case e_cmdTypeMessage.params_more_max: {
			
			return "\"" + p_command + "\" must recieve no more than " + string(p_maxParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
			break;
		}
		
	}
	
	
}




