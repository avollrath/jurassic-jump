extends Control

@onready var high_score: Label = $Panel/HighScore
@onready var winner: Control = $"."
@onready var main_menu: Control = $"../MainMenu"
@onready var background_image: TextureRect = $"../BackgroundImage"

func _ready() -> void:
	GameManager.set_final_score_label(high_score)


func _on_button_pressed() -> void:
	AudioManager.winner_music.stop()
	AudioManager.background_music.stream = ResourcePaths.loaded_resources["res://assets/music/backgroundMusic1.mp3"] as AudioStream
	AudioManager.background_music.play()
	winner.hide()
	background_image.show()
	main_menu.show()
