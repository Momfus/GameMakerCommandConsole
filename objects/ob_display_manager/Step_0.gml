/// @desc Zoom display control

var l_zoomIn = keyboard_check_pressed(vk_add),
	l_zoomOut = keyboard_check_pressed(vk_subtract),
	l_zoom = l_zoomIn - l_zoomOut;
	
if( l_zoom != 0 ) {
	
	__zoom = clamp(__zoom + l_zoom, 1, __maxZoom);
	window_set_size( __idealWidth * __zoom, __idealHeight * __zoom );
	surface_resize(application_surface, __idealWidth * __zoom, __idealHeight * __zoom);
	display_set_gui_size(__idealWidth * __zoom, __idealHeight * __zoom);
	alarm[0] = 1;
	
}
