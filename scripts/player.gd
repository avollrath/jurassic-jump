extends CharacterBody2D

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -700.0
@export var DECELERATION = 200.0  # Rate of slowing down when no input is provided.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle player-initiated jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	# Get the input direction.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction != 0:
		# Apply movement.
		velocity.x = direction * SPEED
	else:
		# Decelerate smoothly when no input is provided.
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	move_and_slide()

# Function to handle jumping.
func jump(custom_jump_velocity: float = JUMP_VELOCITY) -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
	else:
		velocity.y = custom_jump_velocity
