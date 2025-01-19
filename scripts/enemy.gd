extends Area2D


@export var enemy_sound_file: AudioStream
@export var SPEED: int = 30
@export var jump_boost: float = -1500
@export var can_be_stomped: bool = true  # Whether this enemy can be stomped
@onready var ray_cast_front: RayCast2D = $RayCastFront
@onready var ray_cast_back: RayCast2D = $RayCastBack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var enemy_sound: AudioStreamPlayer2D = $EnemySound

func _ready() -> void:
	enemy_sound.stream = enemy_sound_file
	enemy_sound.play()
	
var direction = -1
var got_stomped: bool = false

var stomp_velocity: float = 0
var stomp_acceleration: float = 5000.0

func _process(delta: float) -> void:
	
	if got_stomped:
		stomp_velocity += stomp_acceleration * delta
		position.y += stomp_velocity * delta 
		animated_sprite.flip_v = true
	else:
		if direction == -1 and ray_cast_front.is_colliding():
			position.x += direction * SPEED * delta
		else:
			direction = 1
			animated_sprite.flip_h = true

		if direction == 1 and ray_cast_back.is_colliding():
			position.x += direction * SPEED * delta
		else:
			direction = -1
			animated_sprite.flip_h = false

func _on_body_entered(body: Node2D) -> void:
	var y_delta = position.y - body.position.y
	if can_be_stomped and y_delta > 30:
		get_stomped(body)
	else:
		hit_player(body)

func get_stomped(body: Node2D) -> void:
	body.jump(jump_boost)
	body.deal_damage()
	position.y = position.y - 50
	got_stomped = true
	
	AudioManager.fight_sound.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func hit_player(body: Node2D) -> void:
	body.get_damage(global_position)
	
