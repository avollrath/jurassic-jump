extends Node

var score = 0
var lives = 3
var hearts: Array[TextureRect] = [] 
var label : Label

func set_score_label(new_label : Label):
	label = new_label
	
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
		get_tree().reload_current_scene()
