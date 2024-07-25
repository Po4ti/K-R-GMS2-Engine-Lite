#region Variable and Input Checks

grav = grav_amount * global.grav;

var left = null; 
var right = null; 
var dir = 0;


left = (global.controls_reverse) ? is_held(global.controls.right) : is_held(global.controls.left);
right = (global.controls_reverse) ? is_held(global.controls.left) : is_held(global.controls.right);


var dir_left = left;
var dir_right = right;

#endregion
      
global.player.angle = image_angle;


#region Movement Checks
//If the player is frozen no movement is applied
if (!frozen) {
	if (dir_right || dir_left) {
		dir = (dir_right) ? 1 : -1; 
	}
}
	
#region Collision Checks
on_block = instance_place_check(x, y + global.grav, objBlock, tangible_collision);
on_ice = instance_place_check(x, y + global.grav, objIceBlock, tangible_collision);
	
on_conveyor = instance_place_check(x, y + global.grav, objConveyorBlock, tangible_collision);
on_elevator = instance_place_check(x + xscale, y, objElevatorBlock, tangible_collision);
#endregion
	
#region Vine Checks
var vine_off = 1;
var on_vine = (instance_place_check(x + vine_off, y, objVine, tangible_collision) ?? instance_place_check(x - vine_off, y, objVine, tangible_collision));
	
#endregion
	
	
#endregion
	
#region Horizontal Movement

if (dir != 0) {
	if (on_vine == null) {
		xscale = dir;
	}
	
	if ((dir == 1 && on_vine == null) || (dir == -1 && on_vine == null)) {
		if (on_ice == null) {
			hspd = (global.slippage == 0) ? max_hspd * dir : approach(hspd, max_hspd * dir, global.slippage);
		} else {
			#region Ice Movement

			var max_slipspd = 1;
			hspd = approach(hspd, (max_hspd * max_slipspd) * dir, on_ice.slip);
				
			#endregion
		}
				
		player_sprite("Run");
	}
} else {

	hspd = (on_ice == null) ? 0 : approach(hspd, 0, on_ice.slip);	
	player_sprite("Idle");
}
	
if (on_conveyor != null) {
	hspd += on_conveyor.hspd; 
}
#endregion

#region Vertical Movement
if (!on_platform) {
	if (vspd * global.grav < -0.05) {
		player_sprite("Jump");
	} else if (vspd * global.grav > 0.05) {
		player_sprite("Fall");
	}
} else {
	if (instance_place_check(x, y + 4 * global.grav, objPlatform, tangible_collision) == null) {
		on_platform = false;
	}
}
	
if (on_elevator != null) {
	vspd += on_elevator.vspd;
		
	if (instance_place_check(x, y - vspd * global.grav, objBlock, tangible_collision) == null) {
		if (vspd * global.grav <= 0) {
			player_sprite("Jump");
		} else if (vspd * global.grav > 0) {
			player_sprite("Fall");
		}
	}
}

if (vspd * global.grav > max_vspd) {
	vspd = max_vspd * sign(vspd);
}
#endregion

#region Player Actions
if (!frozen) {
	#region Controls
	if (is_pressed(global.controls.jump)) {
		player_jump();
	}
	
	if (is_released(global.controls.jump)) {
		player_fall();
	}
	#endregion

	#region Vines
	if (on_vine != null) {
		xscale = (on_vine.image_xscale == 1) ? 1 : -1;

		var vine_speed = 1;
		vspd = (2 * vine_speed) * global.grav;
				
		player_sprite("Slide");
    
		if ((on_vine.image_xscale == 1 && is_pressed(global.controls.right)) || (on_vine.image_xscale == -1 && is_pressed(global.controls.left))) {
			if (is_held(global.controls.jump)) {
			    hspd = (on_vine.image_xscale == 1) ? 15 : -15;
						
				vspd = -9 * global.grav;
			    player_sprite("Jump");
				audio_play_sound(sndVine, 0, false);

			} else {
			    hspd = (on_vine.image_xscale == 1) ? 3 : -3;
			    player_sprite("Fall");
			}
		}
				
	}
			
	#endregion
	
	#region Debug
	if (global.debug_enable && on_block) {
		dir = (is_pressed(global.controls_debug.alignR) - is_pressed(global.controls_debug.alignL));
		
		if (dir != 0) {
			hspd = dir;
		}
	}
	#endregion
	
}
#endregion


if (!frozen) {
	if (is_pressed(global.controls.shoot) && !global.controls_lock.shoot) {
		player_shoot();
	}
	
	if (is_pressed(global.controls.suicide) && !global.controls_lock.suicide) {
		kill_player();
	}
}

#region Physics and Collision
//Storing the previous x and y
xprevious = x;
yprevious = y;

//Moving the player manually
vspd += grav;
x += hspd;
y += vspd;

#region Collision with block
var block = instance_place_check(x, y, objBlock, tangible_collision);

if (block != null) {
	x = xprevious;
	y = yprevious;

	if (global.collision_type == 0) {
		#region Detect horizontal collision
		if (instance_place_check(x + hspd, y, objBlock, tangible_collision) != null) {
			while (instance_place_check(x + sign(hspd), y, objBlock, tangible_collision) == null) {
				x += sign(hspd);
			}
		
			hspd = 0;
		}
		#endregion
	
		#region Detect vertical collision
		if (instance_place_check(x, y + vspd, objBlock, tangible_collision) != null) {
			while (instance_place_check(x, y + sign(vspd), objBlock, tangible_collision) == null) {
				y += sign(vspd);
			}
		
			if (vspd * global.grav > 0) {
				reset_jumps();
			}
		
			vspd = 0;
			grav = 0;
		}
		#endregion
	
		#region Detect diagonal collision
		if (instance_place_check(x + hspd, y + vspd, objBlock, tangible_collision) != null) {
			var platform = instance_place_check(x, y + vspd, objPlatform, tangible_collision);
				
			if (!platform || instance_place_check(x, y, platform, tangible_collision) != null) {
				hspd = 0;
			} else {
				vspd = 0;
			}
		}
		#endregion
			
		x += hspd;
		y += vspd;
		
		//Makes player move based on the block speed
		/*if (instance_place_check(x + block.hspeed, y, objBlock, tangible_collision) == null) {
			x += block.hspeed;
		}
		
		if (instance_place_check(x, y + block.vspeed, objBlock, tangible_collision) == null) {
			y += block.vspeed;
		}*/
	} else if (global.collision_type == 1) {
		#region Detect horizontal collision
		var block_x = move_and_collide(hspd, 0, objBlock, abs(hspd), sign(hspd));
		if (array_length(block_x) > 0) {
			hspd = 0;
		}
		#endregion
			
		#region Detect vertical collision
		var block_y = move_and_collide(0, vspd, objBlock, abs(vspd),, sign(vspd));
		if (array_length(block_y) >= 0) {
			if (vspd * global.grav > 0) {
			    reset_jumps();
			}
			    
			vspd = 0;
			grav = 0;
		}
		#endregion
	}
	
}

xsafe = xprevious + hspd;
ysafe = yprevious + vspd;
#endregion
#endregion