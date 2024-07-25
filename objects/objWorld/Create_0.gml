if (instance_number(objWorld) > 1) {
	instance_destroy();
	exit;
}

u_texelsPerPixel = shader_get_uniform(shdPxUpscale, "u_texelsPerPixel");

pause_delay = global.total_pause_delay;
pause_screen = noone;