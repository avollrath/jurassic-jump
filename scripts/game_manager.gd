extends Node

var score = 0
var lives = 3
var hearts: Array[TextureRect] = [] 
var label : Label
var current_level_scene: PackedScene 

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
		reload_level()

func reload_level():
	if current_level_scene:
		var main_node = get_node("/root/main")

		# Find the current level node manually
		var current_level = null
		for child in main_node.get_children():
			if child.name.begins_with("Level"):
				current_level = child
				break

		# Remove the current level if found
		if current_level:
			current_level.queue_free()

		# Reload and instance the current level scene
		var new_level = current_level_scene.instantiate()
		main_node.add_child(new_level)
