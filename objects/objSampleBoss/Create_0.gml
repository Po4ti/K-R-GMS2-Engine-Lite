function SampleAvoidance(_start, _music, _bpm) : AvoidanceParent(_start, _music, _bpm) constructor {
	
	
	val = [358, 385, 396, 405, 414, 422, 435, 462, 473, 483, 494, 503, 515, 543, 554, 565, 574, 583, 593];
	static parent_update = update;
	
	static parent_draw = draw;
	
	static update = function()
	{
		parent_update();
		
		if(in_beat_range(1, 15, 4) || in_beat_range(15, 16)) {
			repeat(24) {
				with(instantiate_projectile(400, 304)) {	
					speed = random_range(5, 7);
					direction = random(360);
					
					var curvComp = add_component(Curving);
					curvComp.curv = choose(-3, 3);
					
					var curvTimer = add_component(CurvingTimer);
					curvTimer.time = 50;	
				}
			}
		}
		if(time_in_array(val)) {
			repeat(5) {
				with(instantiate_projectile(400, 304)) {	
					direction = random(360);
					image_blend = c_yellow;
					
					var sineMove = add_component(SineMovement);
					sineMove.spd_min = 2;
					sineMove.spd_min = 12;
					sineMove.wiggle_power = 10;
					sineMove.t = random(360);
				}
			}
		}		
		if(in_beat_range(33, 55, 1)) {
			repeat(10) {
				with(instantiate_projectile(400, 304, AdditionDrawing)) {	
					direction = random(360);
					
					var curvComp = add_component(Curving);
					curvComp.curv = choose(-0.8, 0.8);
					
					var sineMove = add_component(SineMovement);
					sineMove.spd_min = 1;
					sineMove.spd_min = 7;
					sineMove.wiggle_power = 15;
					sineMove.t = random(360);
				}
			}
		}
	}
	
	static draw = function()
	{
		parent_draw();	
	}
}

new SampleAvoidance(global.debug_avoidance_time, bgmSampleAvoidance, 150);