///@func	fn_cmdSumNumber()
///@param	{real}	p_n1
///@param	{real}	p_n2
///return	void
function fn_cmdSumNumber(p_n1, p_n2){

	fn_cmdArrayPushFIFO(_cmdLogMsgArray, string(p_n1) + " + " + string(p_n2) + " = " + string(p_n1 + p_n2) );
}

///@func	fn_cmdTestSum
///@param	{any}	p_n1
///@param	{any}	p_n2
///@return	void
///@desc	Add two numbers and show the result. This function was created to show how to use in a real project
function fn_cmdTestSum(p_n1, p_n2){

	// One solution is just make all the parameter control inside the direct function
	#region Direct Solution
		//try {
	
		//	p_n1 = real(p_n1);
		//	p_n2 = real(p_n2);
		//	fn_cmdArrayPushFIFO(_cmdLogMsgArray, string(p_n1) + " + " + string(p_n2) + " = " + string(p_n1 + p_n2) );
		
		//} catch(error) {
	
		//	show_debug_message(error)
		
		//	fn_cmdMsgShowError(error.message);
		//	fn_cmdMsgShowError("The function only use numbers as argument");
	
		//}

	#endregion

	// Other solution is have a "indirect function" (like this) and call the real one after checking the arguments. Good for complex functions or to existing ones
	#region Use indirect function
	try {
	
		p_n1 = real(p_n1);
		p_n2 = real(p_n2);
		fn_cmdSumNumber(p_n1, p_n2);
		
	} catch(error) {
	
		show_debug_message(error)
		
		// Feather ignore once GM2017
		fn_cmdMsgShowError(error.message);
		fn_cmdMsgShowError("The function only use numbers as argument");
	}
	
	#endregion
	

}