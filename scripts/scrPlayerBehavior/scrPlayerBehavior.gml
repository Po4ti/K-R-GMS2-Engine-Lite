function player_jump() {
	var platform = instance_place_check(x, y + global.grav, objPlatform, tangible_collision);
		
	if (jump_total > 0 && (on_block != null || (platform != null && platform.visible) || on_platform || instance_place_check(x, y + global.grav, objWater1, tangible_collision) != null || on_ladder)) {
		vspd = -(jump_height[0] * global.grav);
		on_ladder = false;
		player_sprite("Jump");
		reset_jumps();
		audio_play_sound(sndJump, 0, false);
	} else if (jump_left > 0 || instance_place_check(x, y + global.grav, objWater2, tangible_collision) != null || jump_total == -1) {
		var jump_velocity = 1;
				
		vspd = -((jump_height[1] * global.grav) * jump_velocity);
		player_sprite("Jump");
			
		if (instance_place_check(x, y + global.grav, objWater3, tangible_collision) == null) {
			if (jump_left > 0) {
				jump_left--;
			}
		} else {
			reset_jumps();
		}
			
		audio_play_sound(sndDoubleJump, 0, false);
	}
}


function player_fall() {
	if (vspd * global.grav < 0) {
		vspd *= 0.45;
	}
}

function player_shoot() {
	var bullet_max = 4;
	var bullet_object = objBullet;
	var shoot_sound = sndShoot;

	if (instance_number(objBullet) < bullet_max) {
		instance_create_layer(x, y, "Player", bullet_object);
		audio_play_sound(shoot_sound, 0, false);
	}
}

function player_sprite(action = null) {
	sprite_index = get_skin_sprite(action);
}

function get_skin_sprite(action) {
	if (!variable_struct_exists(skins, skin)) {
		return sprite_index;
	}
	
	var sprites = skins[$ skin];
	
	if (!variable_struct_exists(sprites, action)) {
		return sprite_index;
	}
	
	return sprites[$ action];
}

function reset_jumps() {
	with (objPlayer) {
		jump_left = jump_total - 1;
	}
}

function kill_player() {
	if (instance_exists(objPlayer)) {
	    if (!global.debug_god_mode) {
	        with (objPlayer) {
				instance_create_layer(x, y, "Player", objBloodEmitter);
	            instance_destroy();
	        }
            
			instance_create_layer(0, 0, "Instances", objGameOver);
	        global.deaths++;
			audio_play_sound(sndDeath, 0, false);
			
			if (global.death_music) {
	            audio_pause_sound(global.current_music);
	            audio_play_sound(bgmGameOver, 0, false, 0.5);
	        }
	    } else if (objPlayer.hit == 0) {
			with (objPlayer) {
				hit = global.debug_hit_time;
				hit_x = x;
				hit_y = y;
			}
			
			global.deaths++;
			audio_play_sound(sndDeath, 0, false);
		}
	}
}

function outside_room() {
	if (!instance_exists(objPlayer)) {
	    return false;
	}
	
	return (objPlayer.x < 0 || objPlayer.x > room_width || objPlayer.y < 0 || objPlayer.y > room_height);
}

function set_mask() {
	if (abs(global.grav) == 1) {
		mask_index = (global.grav == 1) ? sprPlayerMask : sprPlayerMaskFlipped;
	} else if (abs(global.grav) == 2) {
		mask_index = (global.grav == 2) ? sprPlayerMaskX : sprPlayerMaskXFlipped;
	}
}

function flip_grav(jump = true) {
	if (instance_exists(objPlayer)) {
	    global.grav *= -1;

	    with (objPlayer) {
			set_mask();
	        vspd = 0;
	        y += 4 * global.grav;
	    }
    
		if (jump) {
			reset_jumps();
		}
	}
}