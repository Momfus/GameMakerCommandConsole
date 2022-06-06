/// @desc

x += __movH * __speed;
y += __movV * __speed;

x = clamp(x, __limitMovLeft, __limitMovRigth);
y = clamp(y, __limitMovUp, __limitMovDown);
