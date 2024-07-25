#region Init
set_mask();
xscale = global.last_xscale;
image_angle = global.save_player.sangle;

#endregion

#region Local Speed
hspd = 0;
vspd = 0;
grav = 0;
#endregion

#region Max Speed
max_hspd = 3;
max_vspd = 9;
grav_amount = 0.4;
#endregion

#region Speed Modifiers
spd_mod = {
	//Common 
	fast: 0,
	slow: 0,
}

grav_mod = {
	//Common 
	low: 0,
	high: 0,
};

#endregion

#region Jump Variables
jump_height = [8.5, 7];
jump_total = 2;

#endregion

#region Collision and Actions

on_block = false;
on_ice = false;

on_conveyor = false;
on_elevator = false;

on_platform = false;
on_ladder = false;

lunar_start = false;

test_dist = {
	orig: 0,
	xpos: 0,
	ypos: 0,
	xneg: 0,
	yneg: 0
}

frozen = false;

skins = {
	"Normal": {
		"Idle": sprPlayerIdle,
		"Run": sprPlayerRun,
		"Jump": sprPlayerJump,
		"Fall": sprPlayerFall,
		"Slide": sprPlayerSlide,
		
	}
};

skin = "Normal";
reset_jumps();

xsafe = x;
ysafe = y;

dynamic_collision(true);

hit = 0;
hit_x = x;
hit_y = y;

#endregion