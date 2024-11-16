/// Function using to show custom debug messages

enum e_cmdTypeMessage {
	paramsLessMin,
	paramsMoreMax,
	commandNotExists
}

///@func	fn_cmdMsgShowError(errorMsg, objectArrayMsgOwned*)
///@desc	Show the error msg
///@param	{string}		p_message
///@param	{Id.Instance}	p_objectArrayMsgOwned - Also it could be id.object
///@return	{string}		erroMsg: String
function fn_cmdMsgShowError(p_message, p_objectArrayMsgOwned = undefined ) {

	var arrayToUse = (p_objectArrayMsgOwned != undefined) ? p_objectArrayMsgOwned._cmdLogMsgArray : _cmdLogMsgArray;
		
	fn_cmdArrayPushFIFO(arrayToUse, "[ERROR] " + p_message);
		
}


///@func	fn_cmdMsgGetGenericMessage(type, command, paramTotalGiven, minParams, maxParams)
///@desc	Get the correct message generic message with the given type
///@param	{Real}		p_type				- Must be with the e_cmdTypeMessage enum
///@param	{String}	p_command
///@param	{Real}		p_paramTotalGiven
///@param	{Real}		p_minParams
///@param	{Real}		p_maxParams
///@return	{String}	message
function fn_cmdMsgGetGenericMessage( p_type, p_command, p_paramTotalGiven = 0, p_minParams = 0, p_maxParams = 0 ) {
	
	switch( p_type ) {
		
		case e_cmdTypeMessage.commandNotExists: {
			return "The \"" + p_command + "\" command isn't recognized";
		}
		
		case e_cmdTypeMessage.paramsLessMin: {
			return "\"" + p_command + "\" need at least " + string(p_minParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
		}
		
		case e_cmdTypeMessage.paramsMoreMax: {
			return "\"" + p_command + "\" must recieve no more than " + string(p_maxParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
		}
		
	}
	
}




