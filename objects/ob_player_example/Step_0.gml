///@desc

x += _movH * _speed;
y += _movV * _speed;

x = clamp(x, _limitMovLeft, _limitMovRigth);
y = clamp(y, _limitMovUp, _limitMovDown);
