extends Area2D

@export var SPEED: int = 30
@export var jump_boost: float = -1500
@export var can_be_stomped: bool = true  # Whether this enemy can be stomped
@onready var ray_cast_front: RayCast2D = $RayCastFront
@onready var ray_cast_back: RayCast2D = $RayCastBack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction = -1

func _process(delta: float) -> void:
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
		stomped(body)
	else:
		hit_player(body)

func stomped(body: Node2D) -> void:
	body.jump(jump_boost)
	AudioManager.fight_sound.play()
	queue_free()

func hit_player(body: Node2D) -> void:
	print("decrease life")
