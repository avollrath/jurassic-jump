extends CharacterBody2D
@onready var flicker_timer: Timer = $FlickerTimer
@onready var particles: GPUParticles2D = $FightParticles
@onready var wheels_particles: GPUParticles2D = $WheelsParticles
@onready var camera: Camera2D = $Camera2D

@onready var timer: Timer = $Timer
@export var SPEED = 400.0
@export var JUMP_VELOCITY = -1400.0
@export var DECELERATION = 200.0  # Rate of slowing down when no input is provided.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player_got_hit: bool = false
var player_invincible: bool = false
var was_in_air: bool = false
var just_landed: bool = false
@onready var original_modulate := animated_sprite.modulate

func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	camera.enabled = true

func _physics_process(delta: float) -> void:
	# 1) Apply gravity if not on floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2) Handle horizontal movement
	if not player_got_hit:
		var direction := Input.get_axis("move_left", "move_right")

		if direction != 0:
			velocity.x = direction * SPEED
			animated_sprite.flip_h = (direction < 0)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

		# Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
			AudioManager.jump_sound.play()

	# 3) Move and slide here so collisions are calculated
	move_and_slide()

	# 4) Now `is_on_floor()` is up-to-date
	var on_floor_now = is_on_floor()
	if was_in_air and on_floor_now:
		just_landed = true
		wheels_particles.emitting = true
		particles.one_shot = true
		AudioManager.land_sound.play()
	else:
		just_landed = false

	# 5) Update was_in_air
	was_in_air = not on_floor_now


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
		if not player_invincible:
			GameManager.decrease_health()
			player_invincible = true
		player_got_hit = true
		timer.start()
		
	var knockback_force := Vector2.ZERO
	if global_position.x < enemy_global_position.x:
		knockback_force.x = -500
	else:
		knockback_force.x = 500
		
	knockback_force.y = -600
		
	velocity = knockback_force
		
	flicker_red(1)

func _on_timer_timeout() -> void:
	player_got_hit = false
	
func flicker_red(duration: float) -> void:
	var flicker_time := duration
	var flicker_interval := 0.15
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
		
	animated_sprite.modulate = original_modulate
	player_invincible = false



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
