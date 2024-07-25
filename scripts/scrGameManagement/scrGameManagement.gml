function save_game(position) {
	if (position) {
		global.save_player.sroom = room_get_name(room);
		global.save_player.sx = floor(objPlayer.x);
		global.save_player.sy = floor(objPlayer.y);
		global.save_player.sangle = global.player.angle;
		global.save_player.sgrav = global.grav;
	}
	
	var data = {
		player: global.save_player,
		
		info: {
			difficulty: global.difficulty,
			deaths: global.deaths,
			time: global.time,
			clear: global.clear
		},
		
		items: global.items
	};
	
	var json = json_stringify(data);
	save_file(string("Data{0}", global.save_num + 1), json, true);
	
}

function load_game(position) {
	if (instance_exists(objPlayer)) {
		instance_destroy(objPlayer);
	}
	
	var json = load_file(string("Data{0}", global.save_num + 1), true);
	var data = json_parse(json);
	
	global.save_player = data.player;
	global.deaths = data.info.deaths;
	global.time = data.info.time;
	global.difficulty = data.info.difficulty;
	global.clear = data.info.clear;
	global.items = data.items;
	
	if (position) {
		global.game_started = true;
		global.auto_save = false;
		global.grav = global.save_player.sgrav;
		instance_create_layer(global.save_player.sx, global.save_player.sy, "Player", objPlayer);
		room_goto(asset_get_index(global.save_player.sroom));
	}
	
}

function cleanup_game() {
	global.grav = 1;
	global.deaths = 0;
	global.time = 0;
	global.clear = false;
	
	global.player = {
		xx: 0,
		yy: 0,
		angle: global.save_player.sangle
	};
	
	global.slippage = 0;
	
	global.items = {
		secrets: array_create(8, false),
		bosses: array_create(8, false)
	};
	
}

function start_game(diff) {
	var save = string("Data{0}", global.save_num + 1);
	var length = array_length(global.difficulties);

	if (diff == length - 1) {
	    load_game(true);
	} else {
		diff = clamp(diff, 0, length - 1);

	    if (file_exists(save)) {
	        file_delete(save);
	    }
        
	    global.game_started = true;
	    global.auto_save = true;
	    global.difficulty = diff;

	    instance_destroy(objPlayer);
	    room_goto(global.start_room);
	}
}

function restart_game() {
	if (global.death_music) {
	    audio_stop_sound(bgmGameOver);
	    audio_resume_sound(global.current_music);
	}
	
	var deaths = global.deaths;
	var time = global.time;
	load_game(true);
	global.deaths = deaths;
	global.time = time;
	
	with (objTriggerController) {
		ds_list_clear(trigger_active_keys);
		ds_list_clear(trigger_active_ids);
	}
}

function end_game() {
	if (global.game_started) {
		restart_game();
		save_game(false);
		save_config();
		global.game_started = false;
	}
}

function save_config() {
	var data = {
		display: global.display,
		controls: global.controls,
	};
	
	var json = json_stringify(data);
	save_file("Config.ini", json, false);
}

function load_config() {
	if (!file_exists("Config.ini")) {
		save_config();
	}
	
	var json = load_file("Config.ini", false);
	var data = json_parse(json);
	
	global.display = data.display;
	global.controls = data.controls;
	
	set_display();
}

function set_display() {
	window_set_fullscreen(global.display.fullscreen);
	
	if (global.display.vsync) {
		display_reset(0, global.display.vsync);
	}
	
	display_set_gui_size(surface_get_width(application_surface), surface_get_height(application_surface));
}

function change_volume(type = "master") {
	var dir = (is_held(global.controls.right) - is_held(global.controls.left));
	global.display[$ type + "_volume"] += 0.01 * dir;
	global.display[$ type + "_volume"] = clamp(global.display[$ type + "_volume"], 0, 1);
}