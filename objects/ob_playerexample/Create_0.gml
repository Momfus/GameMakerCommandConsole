/// @desc Attributes

__moveLeft = false;
__moveRigth = false;
__moveDown = false;
__moveUp = false;

__speed = 5;


var l_spriteHalf = sprite_width * 0.5;

__limitMovLeft = l_spriteHalf;
__limitMovRigth = room_width - l_spriteHalf;
__limitMovUp = l_spriteHalf;
__limitMovDown = room_height - l_spriteHalf;