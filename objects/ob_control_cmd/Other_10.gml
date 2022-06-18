/// @desc Methods - Begin Step

/// @function StateBeginStep_closed();
/// @desc Set the begin state when the cmd is closed
function StateBeginStep_closed() {
	  
	#region Check if the user want to open cmd
		fn_CMDControl_checkSpecilKeyInput();
		if (__cmdKeyPressedShowHide) {
			show_debug_message("Open cmd");
			__currentState = e_cmdState.opened;
			__currentState_beginStep = StateBeginStep_opened;
		}
	#endregion
	
}

/// @function StateBeginStep_opened();
/// @desc Set the begin state when the cmd is opened
function StateBeginStep_opened() {
	
	if ( __currentState == e_cmdState.opened ) {
  
		// Check first if the user want to close the cmd panel
		fn_CMDControl_checkSpecilKeyInput();
		if (__cmdKeyPressedShowHide) {
	    
			show_debug_message("Close cmd");
			__currentState = e_cmdState.closed;
			__currentState_beginStep = StateBeginStep_closed;
			
			surface_free(__surfCmdWindow);
			
		} else 
			
			// Input CMD
			fn_CMDControl_inputKeyboardUser();
			
			// Mouse event control
			fn_CMDControl_checkMouseEvent(); // Global mouse check (not necesarry when is hover the CMD

			__cmdMouseHover = fn_cmdGUICheckMouseIsHoverThisObject(__cmdMouseHover);
			if( __cmdMouseHover ) {
				fn_CMDControl_inputMouse();
			}
		}
			
}
