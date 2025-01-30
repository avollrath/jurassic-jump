extends Control

@onready var high_score: Label = $Panel/HighScore
@onready var button: Button = $Panel/Button
@onready var main_menu: Control = $"../MainMenu"
@onready var game_over: Control = %GameOver
@onready var background_image: TextureRect = $"../BackgroundImage"

func _ready() -> void:
	GameManager.set_highscore_label(high_score)

func _on_button_pressed() -> void:
	AudioManager.game_over_music.stop()
	AudioManager.background_music.stream = ResourcePaths.loaded_resources["res://assets/music/backgroundMusic1.mp3"] as AudioStream
	AudioManager.background_music.play()
	game_over.hide()
	background_image.show()
	main_menu.show()
  
