extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Reference to the Sprite2D node
var sprite: Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Get the Sprite2D node
	sprite = $Sprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED

		# Flip the sprite based on the direction
		sprite.scale.x = sign(direction) * abs(sprite.scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
