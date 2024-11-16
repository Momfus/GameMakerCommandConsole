///@func	fn_cmdSumNumber()
///@param	{real}	n1
///@param	{real}	n2
///return	void
function fn_cmdSumNumber(n1, n2){

	fn_cmdArrayPushFIFO(_cmdLogMsgArray, string(n1) + " + " + string(n2) + " = " + string(n1 + n2) );
}

///@func	fn_cmdTestSum
///@param	{any}	n1
///@param	{any}	n2
///@return	void
///@desc	Add two numbers and show the result. This function was created to show how to use in a real project
function fn_cmdTestSum(n1, n2){

	// One solution is just make all the parameter control inside the direct function
	#region Direct Solution
		//try {
	
		//	n1 = real(n1);
		//	n2 = real(n2);
		//	fn_cmdArrayPushFIFO(_cmdLogMsgArray, string(n1) + " + " + string(n2) + " = " + string(n1 + n2) );
		
		//} catch(error) {
	
		//	show_debug_message(error)
		
		//	fn_cmdMsgShowError(error.message);
		//	fn_cmdMsgShowError("The function only use numbers as argument");
	
		//}

	#endregion

	// Other solution is have a "indirect function" (like this) and call the real one after checking the arguments. Good for complex functions or to existing ones
	#region Use indirect function
	try {
	
		n1 = real(n1);
		n2 = real(n2);
		fn_cmdSumNumber(n1, n2);
		
	} catch(error) {
	
		show_debug_message(error)
		
		fn_cmdMsgShowError(error.message);
		fn_cmdMsgShowError("The function only use numbers as argument");
	}
	
	#endregion
	

}