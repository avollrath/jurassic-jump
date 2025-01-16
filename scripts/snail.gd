extends Node2D

const SPEED = 30

var direction = -1
@onready var ray_cast_front: RayCast2D = $RayCastFront
@onready var ray_cast_back: RayCast2D = $RayCastBack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if direction == -1 && ray_cast_front.is_colliding():
		position.x += direction * SPEED * delta
	else: 
		direction = 1
		animated_sprite.flip_h = true
	
	if direction == 1 && ray_cast_back.is_colliding():
		position.x += direction * SPEED * delta
	else: 
		direction = -1
		animated_sprite.flip_h = false
	
	
