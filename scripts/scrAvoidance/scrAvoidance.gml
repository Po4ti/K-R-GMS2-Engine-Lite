function AvoidanceParent(_start, _music, _bpm) constructor {
	t = _start;
	bpm = _bpm;
	beat = floor(t / 60 / 50 * bpm)
	desync = 0;
	debug_buffer = [];
	
	depth = layer_get_depth("System");
	layer = layer_get_id("System");
	
	if(t < 0)
		throw("t must be positive")

	stop_music();
	play_music(_music, false);	
	init_avoidance(self);
	
	static update = function() {
		t ++;	
		
		if(t > 0 && (abs(audio_sound_get_track_position(global.current_music) * 50 - t) > 10))
			audio_sound_set_track_position(global.current_music, t / 50);
			
			
		desync = (abs(audio_sound_get_track_position(global.current_music) * 50 - t))
		
		beat = floor(t / 60 / 50 * bpm);
		
		if(keyboard_check_pressed(ord("T"))) {
			global.debug_avoidance_time = get_integer("Time: ", max(0,global.debug_avoidance_time));	
		}
		
		
		if(keyboard_check_pressed(vk_space)) {
			print(t);
			array_push(debug_buffer, t);
		}

		if(keyboard_check_pressed(ord("H"))) {
			var dbg = "val = [";
			for(i = 0; i < array_length(debug_buffer); i ++)
				dbg = dbg + string(debug_buffer[i]) + ", "
			dbg = string_delete(dbg, string_length(dbg) - 1, 2);
			dbg += "];";
	
			print(dbg);
		}
		
		return self;
	}

	static draw = function() {
		draw_debug();
	}
	
	static draw_debug = function() {
		var str = "Time: " + string(t);
		str += "\nDesync: " + string(desync);
		str += "\nBeat: " + string(beat);	
		var yy = global.overlay ? 200 : 20;
		draw_set_text(c_white,fntMenu3, fa_left,fa_top);
		draw_text_outline(20,yy,str,c_black);
	}
	
	static in_beat_range =  function(start, stop=start, step=1) {
		return beat >= start && beat <= stop && (beat - start) % step == 0 && floor(t / 60 / 50 * bpm) != floor((t - 1) / 60 / 50 * bpm);	
	}
		
	static time_in_array = function(array, len=-1) {
		if(len == -1) {
			len = array_length(array);	
		}

		if(t >= array[0] && t <= array[len - 1]) {
			for(var i = 0; i < len; i ++) {
				if(t == array[i])
					return true;
			}
		}
		return false;
	}	

}

function init_avoidance(obj) {
	with(objAvoidanceController) {
		array_push(avoidances, obj);
	}
}