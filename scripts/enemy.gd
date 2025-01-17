extends Area2D

@export var SPEED : int = 30
@export var jump_boost: float = -1000
var direction = -1
@onready var ray_cast_front: RayCast2D = $RayCastFront
@onready var ray_cast_back: RayCast2D = $RayCastBack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fight_sound: AudioStreamPlayer2D = $FightSound


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
	
	
	


func _on_body_entered(body: Node2D) -> void:
	var y_delta = position.y - body.position.y
	print(y_delta)
	if (y_delta > 30):
		print("Play sound")
		AudioManager.fight_sound.play()
		body.jump(jump_boost)
		queue_free()
	else:
		print("decrease life")
