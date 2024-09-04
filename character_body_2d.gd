extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -858.0
const COYOTE_TIME = 0.2
const JUMP_BUFFER_TIME = 0.2
var MAX_ROTATION_ANGLE = 0.05
var ACCELERATION = 4200.0
var DECELERATION = 4200.0

var hasJumped = false
var isAttacking = false

# Reference to the AnimatedSprite2D node
var sprite: AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var time_since_last_grounded = 0.0
var time_since_jump_pressed = JUMP_BUFFER_TIME
var combo = 0

func _ready():
	# Get the AnimatedSprite2D node
	sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 2 * delta
		time_since_last_grounded += delta			
		if not isAttacking and velocity.y > 0 and sprite.animation != "fall":
			sprite.play("fall")
		
	else:
		time_since_last_grounded = 0.0
		hasJumped = false

		# Perform a buffered jump
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
			if not isAttacking and velocity.y < 0 and not sprite.is_playing() or sprite.animation != "jump":
				sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		
		# Flip the sprite based on the direction
		sprite.scale.x = sign(direction) * abs(sprite.scale.x)
		
		# Play the running animation if moving horizontally
		if not isAttacking and is_on_floor() and not sprite.is_playing() or sprite.animation != "run" and velocity.y == 0:
			sprite.play("run")
	else:
		# Decelerate toward zero
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

		# Play the idle animation if not moving horizontally
		if not isAttacking and is_on_floor() and (not sprite.is_playing() or sprite.animation != "idle") or sprite.animation != "attack":
			sprite.play("idle")

	# Rotate the sprite slightly based on the velocity
	sprite.rotation = clamp(velocity.x / SPEED * MAX_ROTATION_ANGLE, -MAX_ROTATION_ANGLE, MAX_ROTATION_ANGLE)
	
	if Input.is_action_just_pressed("ui_attack") and not isAttacking:
		perform_attack()

	move_and_slide()

# Inside perform_attack()
var attackDebounce = false
var attackTime = 0.4
var attackCooldown = 0
func perform_attack():
	if attackDebounce == true: return
	isAttacking = true
	attackDebounce = true
	print(isAttacking)
	SPEED = 0.1
	combo += 1
	attackCooldown = 0
	if combo > 3:
		attackCooldown = 1
		combo = 1
	if (not sprite.is_playing() or sprite.animation != "attack"):
		sprite.play("attack")
	
	# Enable hitbox
	#$AttackHitbox.set_deferred("monitoring", true)

	await get_tree().create_timer(attackTime).timeout

	# Disable hitbox after attack
	#$AttackHitbox.set_deferred("monitoring", false)
	isAttacking = false
	print(isAttacking)
	SPEED = 300.0
	
	await get_tree().create_timer(attackCooldown).timeout
	attackDebounce = false
