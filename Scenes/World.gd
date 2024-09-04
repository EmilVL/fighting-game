extends Node

# World properties
var gravity: Vector2 = Vector2(0, 98.0) # Default gravity (Earth-like gravity)
var time_scale: float = 1.0 # Default time scale
var global_friction: float = 0.5 # Default friction value

# Function to set gravity
func set_gravity(new_gravity: Vector2):
	gravity = new_gravity
	
	# Access the physics space directly from the current scene's space
	var space_state = get_tree().current_scene.get_world_2d().space
	PhysicsServer2D.area_set_param(space_state, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, gravity)
	
	print("Gravity set to: ", gravity)

# Function to set time scale
func set_time_scale(new_time_scale: float):
	time_scale = new_time_scale
	Engine.time_scale = time_scale
	print("Time scale set to: ", time_scale)

# Function to set global friction
func set_global_friction(new_friction: float):
	global_friction = new_friction
	print("Global friction set to: ", global_friction)
