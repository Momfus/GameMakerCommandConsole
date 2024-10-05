///@desc Free Memory

// Free surface from memory
if( variable_instance_exists(self, "_surfCmdWindow") ) {
	surface_free(self._surfCmdWindow);
}

