extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const COYOTE_TIME = 0.2
const JUMP_BUFFER_TIME = 0.2
const MAX_ROTATION_ANGLE = 0.05
const ACCELERATION = 4200.0
const DECELERATION = 4200.0

var Acceleration = Vector2(0, 0)

var hasJumped = false;

# Reference to the Sprite2D node
var sprite: Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var time_since_last_grounded = 0.0
var time_since_jump_pressed = JUMP_BUFFER_TIME

func _ready():
	# Get the Sprite2D node
	sprite = $Sprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		time_since_last_grounded += delta
	else:
		time_since_last_grounded = 0.0
		hasJumped = false
		
		if time_since_jump_pressed <= JUMP_BUFFER_TIME:
			hasJumped = true
			velocity.y = JUMP_VELOCITY
			
	time_since_jump_pressed += delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		time_since_jump_pressed = 0.0  # Reset the buffer timer
		if time_since_last_grounded <= COYOTE_TIME and not hasJumped:
			hasJumped = true
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)

		sprite.scale.x = sign(direction) * abs(sprite.scale.x)
	else:
		# Decelerate toward zero
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		
	sprite.rotation = clamp(velocity.x / SPEED * MAX_ROTATION_ANGLE, -MAX_ROTATION_ANGLE, MAX_ROTATION_ANGLE)

	move_and_slide()
