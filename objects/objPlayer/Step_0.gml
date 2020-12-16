#region Movement
var dir = (is_held(global.controls.right) - is_held(global.controls.left));

if (frozen) {
	dir = 0;
}

on_block = check_block(0, global.grav);
var on_vineR = (place_meeting(x - 1, y, objVineR) && !on_block);
var on_vineL = (place_meeting(x + 1, y, objVineL) && !on_block);
gravity = (!on_block) ? 0.4 * global.grav : 0;

if (dir != 0) {
	if (!on_vineR && !on_vineL) {
		xscale = dir;
	}
	
	if ((dir == 1 && !on_vineR) || (dir == -1 && !on_vineL)) {
		hspeed = max_hspeed * dir;
		image_speed = 0.5;
		sprite_index = PLAYER_ACTIONS.RUN;
	}
} else {
	hspeed = 0;
	image_speed = 0.2;
	sprite_index = PLAYER_ACTIONS.IDLE;
}

if (!on_platform) {
	if (vspeed * global.grav < 0) {
		sprite_index = PLAYER_ACTIONS.JUMP;
	} else if (vspeed * global.grav > 0) {
		sprite_index = PLAYER_ACTIONS.FALL;
	}
} else {
	if (!check_platform(0, 4 * global.grav)) {
        on_platform = false;
    }
}

if (abs(vspeed) > max_vspeed) {
	vspeed = max_vspeed * sign(vspeed);
}

if (!frozen) {
	if (is_pressed(global.controls.jump)) {
		if (jump_total > 0 && (on_block || on_platform || check_platform(0, 0))) {
			vspeed = -(jump_height[0] * global.grav);
			sprite_index = PLAYER_ACTIONS.JUMP;
			reset_jumps();
			audio_play_sound(sndJump, 0, false);
		} else if (jump_left > 0 || place_meeting(x, y, objWater) || jump_total == -1) {
			vspeed = -(jump_height[1] * global.grav);
			sprite_index = PLAYER_ACTIONS.JUMP;
			
			if (!place_meeting(x, y, objWaterRefresh)) {
				if (jump_left > 0) {
					jump_left--;
				}
			} else {
				reset_jumps();
			}
			
			audio_play_sound(sndDoubleJump, 0, false);
		}
	}
	
	if (is_released(global.controls.jump)) {
		if (vspeed * global.grav < 0) {
			vspeed *= 0.45;
		}
	}
	
	if (is_pressed(global.controls.shoot)) {
		if (instance_number(objBullet) < 4) {
		    instance_create_layer(x, y, "Instances", objBullet);
			audio_play_sound(sndShoot, 0, false);
		}
	}
	
	if (on_vineR || on_vineL) {
		xscale = (on_vineR) ? 1 : -1;
	    vspeed = 2 * global.grav;
	    sprite_index = PLAYER_ACTIONS.SLIDE;
	    image_speed = 1 / 2;
    
	    if ((on_vineR && is_pressed(global.controls.right)) || (on_vineL && is_pressed(global.controls.left))) {
	        if (is_held(global.controls.jump)) {
	            hspeed = (on_vineR) ? 15 : -15;
	            vspeed = -9 * global.grav;
	            audio_play_sound(sndVine, 0, false);
	            sprite_index = PLAYER_ACTIONS.JUMP;
	        } else {
	            hspeed = (on_vineR) ? 3 : -3;
	            sprite_index = PLAYER_ACTIONS.FALL;
	        }
	    }
	}
	
	if (global.debug_enable && on_block) {
		dir = (is_pressed(global.controls_debug.alignR) - is_pressed(global.controls_debug.alignL));
		
		if (dir != 0) {
			hspeed = dir;
		}
	}
}
#endregion

#region Block Collisions
if (check_block(hspeed, 0)) {
	x = (hspeed > 0) ? floor(x) : ceil(x);
	
	while (!check_block(sign(hspeed), 0)) {
		x += sign(hspeed);
		
		if (check_killer()) {
			break;
		}
	}
	
	hspeed = 0;
}

if (check_block(0, vspeed)) {
	y = (vspeed > 0) ? floor(y) : ceil(y);
	
	while (!check_block(0, sign(vspeed))) {
		y += sign(vspeed);
		
		if (check_killer()) {
			break;
		}
	}
	
	if (vspeed * global.grav > 0) {
		reset_jumps();
	}
	
	vspeed = 0;
	gravity = 0;
}

if (check_block(hspeed, vspeed)) {
	hspeed = 0;
}
#endregion