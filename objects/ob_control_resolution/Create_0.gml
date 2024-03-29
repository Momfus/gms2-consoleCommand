///@desc Attributes init

application_surface_draw_enable(false);

// This object must be in the beggining of the game in a blank room with the same size as the base widthxheight
fn_isSingleton();

__resShowInfo = true;
__resBaseWidth = 960; // Priorizate the Height for widescreen
__resBaseHeight = 540;

__resIdealWidth = __resBaseWidth;
__resIdealHeight = __resBaseHeight;

__resMaxWidth = 1920;
__resMaxHeight = 1080;


// Check helpers (for GUI resize)
__newResSizeWidth = 0;
__newResSizeHeight = 0;

// Used as a multiplier with current to change some attributes size (like font size in the GUI layer)
__resGUIAspectOffset = 1;
__resGUIWidthOld = __resBaseWidth;

__resDisplayWidth =   display_get_width();
__resDisplayHeight =  display_get_height();
__isNewWindowSizeSetted = false;


// Ini states (if you want to set fullscreen and another resolution in the beggining, create a ini file that is read and then excecute the resolution function
window_set_fullscreen(false);
window_set_size(__resBaseWidth, __resBaseHeight);

#region Functions

///@func	fn_controlResolutionResizeAll()
///@param	{bool}	isFirsTimeStart
///@param	{real}	newWindowWidth
///@param	{real}	newWindowHeight
///@param	{bool}	isPortrait
///@return	void
///@desc	Change the necesary attributes when the resolution is different.
function fn_controlResolutionResizeAll(p_isFirstTimeStart = false, p_newWindowWidth = __resBaseWidth, p_newWindowHeight = __resIdealHeight,  p_isPortrait = false) {
	
	__isNewWindowSizeSetted = false;
	
	var l_isWindowFS = window_get_fullscreen(),
		l_displayReferenceWidth = l_isWindowFS ? __resDisplayWidth : p_newWindowWidth,
		l_displayReferenceHeight = l_isWindowFS ? __resDisplayHeight : p_newWindowHeight;

	
	__resAspectRatio = l_displayReferenceWidth / l_displayReferenceHeight;
	
	if not( p_isPortrait ) {
		__resIdealWidth = round( __resBaseHeight * __resAspectRatio ); // This is for widescreen aspect ratio (aspectRadio > 1);	
		__resIdealHeight = __resBaseHeight;
	} else{
		__resIdealHeight = round( __resBaseWidth * __resAspectRatio ); // This is for portrait aspect ratio (aspectRadio < 1);		
		__resIdealWidth = __resBaseWidth;
	}

	#region Perfect pixel scaling
	
		// For test purposes, is important to adjust not only the width but the height also, it works for differents ratios fixing the camera width and height then 
		
		// Widescreen
		if ( ( not(p_isPortrait) and (l_displayReferenceWidth mod __resIdealWidth ) != 0 ) or not(l_isWindowFS) ) { // Stretch to resolution to maintain dimensions
    
			var l_display = round( l_displayReferenceWidth / __resIdealWidth );
			__resIdealWidth = round(l_displayReferenceWidth / l_display);
			
	
		}
	
		// Portrait (uncomment to enable and comment the other)
		if ( ( p_isPortrait and ( l_displayReferenceHeight  mod __resIdealHeight ) != 0 ) or not(l_isWindowFS) ) { // Stretch to resolution to maintain dimensions
			var l_display = round(l_displayReferenceHeight / __resIdealHeight );
			__resIdealHeight =l_displayReferenceHeight / l_display;  
	
		}
	
	
		// Check for odd resolution numbers. Note: There is any "odd number resolution" but just in case, this will round into a even one
		if( __resIdealWidth & 1 ) {
			__resIdealWidth++;
		}
	
		if( __resIdealHeight & 1 ) {
			__resIdealHeight++;
		}


	#endregion

	/// Set surface and center
	
	window_set_size(p_newWindowWidth, p_newWindowHeight);
	
	surface_resize(application_surface,__resIdealWidth,__resIdealHeight);
	
	fn_controlResolutionResizeGUI(p_newWindowWidth, p_newWindowHeight);

	alarm[0] = 1; // it need at lest one step to center the window
	
	// Checkers for news resize
	if( window_get_fullscreen() ) {
		__newResSizeWidth = __resDisplayWidth;
		__newResSizeHeight = __resDisplayHeight;
	} else {
		__newResSizeWidth = (p_newWindowWidth > __resDisplayWidth )? __resDisplayWidth : p_newWindowWidth;
		__newResSizeHeight = (p_newWindowHeight > __resDisplayHeight)? __resDisplayHeight : p_newWindowHeight;
	}
	
	// This is just to not generate a loop when the object is created (start with the base and if needed, call it again)
	if not( p_isFirstTimeStart) {
		alarm[1] = room_speed * 0.1; // It need at least one step after the rescale is made
	} else {
		__isNewWindowSizeSetted = true;
		room_goto_next();	
	}
	
	
}

///@func	fn_controlResolutionResizeGUI()
///@param	{real}	newGUIWidth
///@param	{real}	newGUIHeight
///@return	void
function fn_controlResolutionResizeGUI(p_newGUIWidth, p_newGUIHeight) {
	
	__resGUIWidthOld = display_get_gui_width();
	
	// Widescreen -> compare with Height for portrait
	if ( p_newGUIWidth > __resMaxWidth ) {
		__resGUIAspectOffset = __resMaxWidth / __resGUIWidthOld;
		display_set_gui_size(__resMaxWidth,__resMaxHeight);
	} else {
		__resGUIAspectOffset = p_newGUIWidth / __resGUIWidthOld;
		display_set_gui_size(p_newGUIWidth, p_newGUIHeight);	
	}

		
}

///@function fn_resizeResolutionToObjects(guiOffsetMultiplier)
///@param {real}	guiOffsetMultiplier
///@return void
///@desc	It used to resize all the objets that depend on the resolution size (like camera and gui elements) 
function fn_resizeResolutionToObjects() {

	ob_camera_main.fn_resizeWindow();
	ob_control_cmd.fn_resizeWindow(__resGUIAspectOffset);
	
}

#endregion


fn_controlResolutionResizeAll(true); // Is important to call this in the beggining
