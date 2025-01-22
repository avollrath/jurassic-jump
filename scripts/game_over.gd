extends Control

@onready var high_score: Label = $Panel/HighScore
@onready var button: Button = $Panel/Button

func _ready() -> void:
	GameManager.set_highscore_label(high_score)

func _on_button_pressed() -> void:
	AudioManager.background_music.play()
	AudioManager.game_over_music.stop()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
