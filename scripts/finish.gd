extends Area2D

@export var target_level: PackedScene
@export var target_level_music: AudioStream
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Ensure the player entered
		body.level_finish_animation()  # Directly call the player's method
		AudioManager.win_sound.play()
		timer.start()

func _on_timer_timeout() -> void:
	if AudioManager.background_music:
		AudioManager.background_music.stream = target_level_music
		AudioManager.background_music.play()
	get_tree().change_scene_to_packed(target_level)
