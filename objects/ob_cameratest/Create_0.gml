/// @desc Camera properties

fn_isSingleton();

/* Important notes: 

	* This is only for one view (no split screen)

	* For now (2022) 1080p is the most widely screen resolution used in monitors.
	Keep the resolution as a multiplier of 1920x1080. Always mantain view, window and application surface (and camera) the same size/aspect ratio.

	* This part is from the Pixelated Pope tutorial video https://youtu.be/_g1LQ6aIJFk

*/

//#macro MAIN_VIEW view_camera[0]

__objectTarget = ob_playerExample;

// I use the maximum resolution i want divided by a number that give me the lower resolution to work on
var l_resolutionMultiplier = 2; 
__cameraWidth = 1920 / l_resolutionMultiplier; // The result is the target base resolution to work
__cameraHeight = 1080 / l_resolutionMultiplier; // The result is the target base resolution to work


// Center view
window_set_size(__cameraWidth, __cameraHeight);
alarm[0] = 1; // It need at least one step to center correctly

// Resize aplication_surface by the window size
surface_resize(application_surface, __cameraWidth, __cameraHeight);



