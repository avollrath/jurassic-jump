extends Area2D

@export var target_level: PackedScene
@export var target_level_music: AudioStream
@onready var timer: Timer = $Timer
@export var is_final_level: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Ensure the player entered
		body.level_finish_animation()  # Directly call the player's method
		AudioManager.win_sound.play()
		timer.start()

func _on_timer_timeout() -> void:
	# Update the background music
	if AudioManager.background_music:
		AudioManager.background_music.stream = target_level_music
		AudioManager.background_music.play()

	if is_final_level:
		GameManager.load_new_level(null, GameManager.LevelType.FINAL)
	else:
		GameManager.load_new_level(target_level, GameManager.LevelType.REGULAR)
