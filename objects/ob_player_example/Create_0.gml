///@desc Attributes

_moveLeft = false;
_moveRigth = false;
_moveDown = false;
_moveUp = false;
_movH = false;
_movV = false;

_speed = 5;


var spriteHalf = sprite_width * 0.5;

_limitMovLeft = spriteHalf;
_limitMovRigth = room_width - spriteHalf;
_limitMovUp = spriteHalf;
_limitMovDown = room_height - spriteHalf;