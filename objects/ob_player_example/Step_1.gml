///@desc Get input

if( global._gCmdOpen ) { return;	} // Skip the next lines if cmd is open

__moveLeft = keyboard_check( ord("A") )		or keyboard_check(vk_left);
__moveRigth = keyboard_check( ord("D") )	or keyboard_check(vk_right);
__moveDown = keyboard_check( ord("S") )		or keyboard_check(vk_down);
__moveUp = keyboard_check( ord("W") )		or keyboard_check(vk_up);

__movH = __moveRigth - __moveLeft;
__movV = __moveDown - __moveUp;