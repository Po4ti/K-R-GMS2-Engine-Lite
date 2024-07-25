var dir = 1;
if (instance_exists(objPlayer)) {
	dir = objPlayer.xscale;
}

var spd = 16;
var time = 40;


hspeed = spd * dir;
alarm[0] = time;
