function Option(label, on_select, get_value) constructor {
	self.label = label;
	self.on_select = on_select;
	self.get_value = get_value;
}

options = [
	[ //Options
		new Option("Music: ", function() {
			global.display.mute_music ^= true;
			toggle_music();
		}, function() {
			return (global.display.mute_music) ? "No" : "Yes";
		}),

	
		new Option("Master Volume: ", function() {
			var dir = (is_held(global.controls_menu.right) - is_held(global.controls_menu.left));
			
			if (dir != 0) {
				change_volume();
			}
		}, function() {
			return string("{0}%", ceil(global.display.master_volume * 100));
		}),
		
		new Option("BGM Volume: ", function() {
			var dir = (is_held(global.controls_menu.right) - is_held(global.controls_menu.left));
			
			if (dir != 0) {
				change_volume("bgm");
			}
		}, function() {
			return string("{0}%", ceil(global.display.bgm_volume * 100));
		}),
		
		new Option("SFX Volume: ", function() {
			var dir = (is_held(global.controls_menu.right) - is_held(global.controls_menu.left));
			
			if (dir != 0) {
				change_volume("sfx");
			}
		}, function() {
			return string("{0}%", ceil(global.display.sfx_volume * 100));
		}),
		
		new Option("Fullscreen: ", function() {
			global.display.fullscreen ^= true;
			set_display();
		}, function() {
			return (global.display.fullscreen) ? "Yes" : "No";
		}),
		
		new Option("VSync: ", function() {
			global.display.vsync ^= true;
			set_display();
		}, function() {
			return (global.display.vsync) ? "Yes" : "No";
		}),
		
		new Option("Reset Defaults", function() {
			scrOptionsConfig();
			toggle_music();
			set_display();
		}, function() {
			return "";
		}),
		
		new Option("Change Controls", function() {
			menu = MENU_OPTIONS.CONTROLS;
			audio_play_sound(sndJump, 0, false);
		}, function() {
			return "";
		})
	],
	
	[ //Controls
		"Left",
		"Right",
		"Up",
		"Down",
		"Jump",
		"Shoot",
		"Restart",
		"Pause",
		
		new Option("Reset Defaults", function() {
			scrControlsConfig();
		}, function() {
			return "";
		})
	]
];

enum MENU_OPTIONS {
	OPTIONS,
	CONTROLS
}

menu = MENU_OPTIONS.OPTIONS;
select = array_create(array_length(options), 0);
spacing = 50;
changing_controls = false;