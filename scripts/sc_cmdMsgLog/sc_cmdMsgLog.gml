
enum enum_cmdTypeMessage {

	params_less_min,
	params_more_max,
	command_not_exists

}

///@func	fn_CMDControl_MsgShowError(errorMsg, objectArrayMsgOwned*)
///@param	{string}		message
///@param	{id.instance}	intanceobjectArrayMsgOwned - Also it could be id.object
///@return	{string}		erroMsg: String
///@desc	Show the error msg
function fn_CMDControl_MsgShowError(p_message, p_objectArrayMsgOwned = undefined ) {

	var l_arrayTouse = p_objectArrayMsgOwned ? p_objectArrayMsgOwned.__cmdLogArrayMsg : __cmdLogArrayMsg;
		
	fn_cmdArrayPushFIFO(l_arrayTouse, "[ERROR] " + p_message);
		

	
}


///@func	fn_CMDControl_MsgGetGenericMessage(type, command, paramTotalGiven, minParams, maxParams)
///@param	{real.enum_cmdTypeMessage}	type
///@param	{string}					command
///@param	{real}						paramTotalGiven
///@param	{real}						minParams
///@param	{real}						maxParams
///@return	{string}					message
///@desc	Get the correct message generic message with the given type
function fn_CMDControl_MsgGetGenericMessage( p_type, p_command, p_paramTotalGiven = 0, p_minParams = 0, p_maxParams = 0 ) {
	
	switch( p_type ) {
		
		case enum_cmdTypeMessage.command_not_exists: {
			
			return "The \"" + p_command + "\" command isn't recognized";
			break;
		}
		
		case enum_cmdTypeMessage.params_less_min: {
			
			return "\"" + p_command + "\" need at least " + string(p_minParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
			break;
		}
		
		case enum_cmdTypeMessage.params_more_max: {
			
			return "\"" + p_command + "\" must recieve no more than " + string(p_maxParams) + " argument/s, but " + string(p_paramTotalGiven) + " were given";
			break;
		}
		
	}
	
	
}




