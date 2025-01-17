extends Area2D

@export var target_level : PackedScene
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	win_sound.play()
	timer.start()
	body.get_node("AnimatedSprite2D").rotation_degrees = -77
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(target_level)
