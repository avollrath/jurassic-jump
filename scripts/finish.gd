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
	# Update the background music
	if AudioManager.background_music:
		AudioManager.background_music.stream = target_level_music
		AudioManager.background_music.play()

	# Replace only the current level
	replace_level(target_level)

func replace_level(new_level_scene: PackedScene):
	var main_node = get_node("/root/main")

	# Find and remove the current level
	var current_level = null
	for child in main_node.get_children():
		if child.name.begins_with("Level"):
			current_level = child
			break

	if current_level:
		current_level.queue_free()  # Remove the current level

		# Instance the new level
		var new_level = new_level_scene.instantiate()
		main_node.add_child(new_level)
