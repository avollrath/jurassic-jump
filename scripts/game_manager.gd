extends Node

var score = 0
var lives = 3
var hearts: Array[TextureRect] = [] 
var label : Label
var highscore_label : Label
var game_over : Control

func set_score_label(new_label : Label):
	label = new_label
	
func set_highscore_label(new_label : Label):
	highscore_label = new_label
	
func set_hearts(new_hearts: Array[TextureRect]) -> void:
	hearts = new_hearts

func add_points(points):
	score += points
	label.text = "Score: " + str(score)

func decrease_health():
	lives -= 1
	if lives > 0:
		AudioManager.damage_sound.play()
		if lives < hearts.size():
			hearts[lives].visible = false
	elif lives == 0:
		AudioManager.damage_sound.play()
		AudioManager.die_sound.play()
		lives = 3
		score = 0
		label.text = "Score: " + str(score)
		for heart in hearts:
			heart.visible = true
		AudioManager.background_music.stop()
		AudioManager.game_over_music.play()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn") # Gets the loaded scene, which is packed, so it'll have to be manually instantiated
		highscore_label.text = "High Score: " + str(score)
