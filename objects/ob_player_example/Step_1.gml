///@desc Get input

if( global._gCmdOpen ) { return;	} // Skip the next lines if cmd is open

_moveLeft = keyboard_check( ord("A") )		or keyboard_check(vk_left);
_moveRigth = keyboard_check( ord("D") )	or keyboard_check(vk_right);
_moveDown = keyboard_check( ord("S") )		or keyboard_check(vk_down);
_moveUp = keyboard_check( ord("W") )		or keyboard_check(vk_up);

// Feather ignore GM1009 GM1043
_movH = _moveRigth - _moveLeft;
_movV = _moveDown - _moveUp;
// Feather restore GM1009 GM1043