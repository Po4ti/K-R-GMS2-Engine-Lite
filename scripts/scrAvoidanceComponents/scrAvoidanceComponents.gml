function init_container() {
	__container__ = [id];
}

function update_container() {
	for(var i = 1; i < array_length(__container__); i++) {
		__container__[i].update(__container__[0]);
	}
}

function draw_container() {
	for(var i = 1; i < array_length(__container__); i++) {
		__container__[i].draw(__container__[0]);
	}
}


function add_component(componentName) {
	if(!variable_instance_exists(id, "__container__")) {
		throw("init_container() must be called before adding components");	
	}
	var component = new componentName();
	array_push(__container__, component);
	return component;
}

function remove_component(componentName) {
	for(var i = 1; i < array_length(__container__); i++) {
		if(is_instanceof(__container__[i], componentName)) {
			array_delete(__container__, i, 1);	
		}
	}		
}

function Component() constructor {
	static update = function(id) {};
	static draw = function(id) {};
}

function Curving() : Component() constructor
{
	curv = 0;
	
	static update = function(id) {
		id.direction += curv;	
	}
}

function SineMovement() : Component() constructor
{
	spd_min = 0;
	spd_max = 0;
	
	wiggle_power = 1;
	
	t = 0;
	
	static update = function(id) {
		var mid = lerp(spd_min, spd_max, 0.5);
		var amp = mid - spd_min;
		id.speed = mid + amp * dsin(t);
		t += wiggle_power;	
	}
}

function CurvingTimer() : Component() constructor
{
	time = 0;	
	static update = function(id) {
		time--;
		if(time <= 0) {
			with(id) {
				remove_component(Curving);
				remove_component(CurvingTimer);
			}
		}
	}
}

function BaseDrawing() : Component() constructor
{	
	static draw = function(id) {
		with(id) {
			draw_self();
		}
	}
}

function AdditionDrawing() : Component() constructor
{	
	static draw = function(id) {
		with(id) {
			gpu_set_blendmode(bm_add);
			draw_self();
			gpu_set_blendmode(bm_normal);
		}
	}
}