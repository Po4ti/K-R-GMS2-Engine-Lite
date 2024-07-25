#region Color
if ((global.debug_enable && global.debug_coloring) && global.debug_inf_jump) {
    image_blend = c_blue;
} else {
	image_blend = c_white;
}

#endregion

#region Draw Variables
var draw_y = y;
var player_xscale = image_xscale;
var player_yscale = image_yscale;

if (global.grav == -1) {
	draw_y++;
}
player_xscale = image_xscale * xscale;
player_yscale = image_yscale * global.grav;

#endregion

#region Skin
if (global.debug_hitbox != 2) {
	draw_sprite_ext(sprite_index, image_index, x, draw_y, player_xscale, player_yscale, image_angle, image_blend, image_alpha);
}
#endregion

#region Equip

if ((global.difficulty == 0 && global.use_bow) || global.debug_god_mode) {
	draw_sprite_ext(sprBow, -1, x, y, xscale, global.grav, image_angle, c_white, 1);
}


#endregion

#region Debug
if (global.debug_hitbox > 0) {
	draw_sprite_ext(mask_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_fuchsia, 0.5 * global.debug_hitbox);
	draw_sprite_ext(mask_index, image_index, xsafe, ysafe, image_xscale, image_yscale, image_angle, c_lime, 0.5 * global.debug_hitbox);
	
}

if (hit > 0) {
	draw_sprite_ext(sprPlayerHit, -1, hit_x, hit_y, 1, 1, 0, c_white, hit / global.debug_hit_time);
}
#endregion