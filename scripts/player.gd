extends CharacterBody2D

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -700.0
@export var DECELERATION = 200.0  # Rate of slowing down when no input is provided.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		# Apply movement.
		velocity.x = direction * SPEED
	else:
		# Decelerate smoothly when no input is provided.
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	move_and_slide() 
