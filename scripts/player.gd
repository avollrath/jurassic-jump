extends CharacterBody2D
@onready var flicker_timer: Timer = $FlickerTimer
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@export var SPEED = 400.0
@export var JUMP_VELOCITY = -1400.0
@export var DECELERATION = 200.0  # Rate of slowing down when no input is provided.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player_got_hit: bool = false

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not player_got_hit:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
			AudioManager.jump_sound.play()

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
	else:
		velocity.y = 0
		velocity.y = custom_jump_velocity
		
func deal_damage() -> void:
	particles.emitting = true
		
func get_damage(enemy_global_position: Vector2) -> void:
	if not player_got_hit:
		player_got_hit = true
		timer.start()
		GameManager.decrease_health()
		
		# Determine direction of knockback based on enemy's position relative to player.
	var knockback_force := Vector2.ZERO
	if global_position.x < enemy_global_position.x:
		# Enemy is to the right of the player, so knockback to the left.
		knockback_force.x = -500
	else:
		# Enemy is to the left of the player, so knockback to the right.
		knockback_force.x = 500
		
	knockback_force.y = -600
		
	velocity = knockback_force
		
		# Start flickering effect.
	flicker_red(0.4)

func _on_timer_timeout() -> void:
	print("Time out!")
	player_got_hit = false
	
func flicker_red(duration: float) -> void:
	var flicker_time := duration
	var original_modulate := animated_sprite.modulate
	var flicker_interval := 0.1
	var elapsed := 0.0

	while elapsed < flicker_time:
		# Set sprite to red with reduced transparency
		animated_sprite.modulate = Color(1, 0, 0, 0.2)
		flicker_timer.wait_time = flicker_interval / 2
		flicker_timer.one_shot = true
		flicker_timer.start()
		await flicker_timer.timeout

		# Revert to original color
		animated_sprite.modulate = original_modulate
		flicker_timer.wait_time = flicker_interval / 2
		flicker_timer.one_shot = true
		flicker_timer.start()
		await flicker_timer.timeout

		elapsed += flicker_interval



func level_finish_animation() -> void:
	set_physics_process(false)
	position.y = 950
	velocity.x = 0
	velocity.y = 0
	# Create a new Tween.
	var tween = get_tree().create_tween().set_parallel(true)

	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0.3, 0.3), 1.0)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 1)
	tween.tween_property($AnimatedSprite2D, "rotation_degrees", 1080, 1.0).set_ease(Tween.EASE_IN)
	tween.tween_property(
		$AnimatedSprite2D, 
		"position:y", 
		$AnimatedSprite2D.position.y - 100, 
		1.0
	).set_ease(Tween.EASE_IN)
