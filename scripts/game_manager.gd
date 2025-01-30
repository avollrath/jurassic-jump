# game_manager.gd
extends Node

enum LevelType {
	REGULAR,
	FINAL
}

var score = 0
var lives = 3
var hearts: Array[TextureRect] = [] 
var label: Label
var highscore_label: Label
var final_score_label: Label
@onready var game_over: Control = $"../main/GameOver"
@onready var ui: CanvasLayer = $"../main/UI"

# Loading state tracking
var is_level_loading := false

func set_score_label(new_label: Label):
	label = new_label
	
func set_highscore_label(new_label: Label):
	highscore_label = new_label
	
func set_final_score_label(new_label: Label):
	final_score_label = new_label
	
func set_hearts(new_hearts: Array[TextureRect]) -> void:
	hearts = new_hearts

func add_points(points):
	score += points
	label.text = "Score: " + str(score)

func decrease_health(cause: String = "default"):
	lives -= 1
	if lives > 0:
		match cause:
			"killzone":
				AudioManager.fall_sound.play()
			"enemy":
				AudioManager.damage_sound.play()
			_:
				AudioManager.damage_sound.play()
		
		if lives < hearts.size():
			hearts[lives].visible = false
	elif lives == 0:
		handle_game_over(cause)

func handle_game_over(cause: String) -> void:
	Engine.time_scale = 0.125
	
	match cause:
		"killzone":
			AudioManager.fall_sound.play()
			AudioManager.die_sound.play()
		"enemy", _:
			AudioManager.damage_sound.play()
			AudioManager.die_sound.play()
	
	highscore_label.text = "High Score: " + str(score)
	for heart in hearts:
		heart.visible = true
	
	AudioManager.background_music.stop()
	AudioManager.game_over_music.play()
	
	await get_tree().create_timer(0.2).timeout
	Engine.time_scale = 1
	lives = 3
	score = 0
	label.text = "Score: " + str(score)
	
	remove_current_level()
	game_over.show()
	ui.hide()

func remove_current_level() -> void:
	var main_node = get_node("/root/main")
	for child in main_node.get_children():
		if child.name.begins_with("Level"):
			child.queue_free()
	# Wait a frame to ensure the level is fully removed
	await get_tree().process_frame

func load_new_level(new_level_scene: PackedScene, level_type: int = LevelType.REGULAR) -> void:
	if is_level_loading:
		return
		
	is_level_loading = true
	var main_node = get_node("/root/main")
	var spinner = main_node.get_node("LoadingSpinner")
	
	# Show and start spinner animation
	spinner.show()
	
	# Give the spinner some frames to start animating
	for i in range(5):
		await get_tree().process_frame
	
	# Remove current level if it exists
	await remove_current_level()
	
	if level_type == LevelType.REGULAR and new_level_scene:
		await load_regular_level(new_level_scene, main_node)
	elif level_type == LevelType.FINAL:
		load_final_level(main_node)
	
	# Give a small delay to ensure everything is ready
	await get_tree().create_timer(0.2).timeout
	
	# Clean up
	spinner.hide()
	is_level_loading = false

func load_regular_level(new_level_scene: PackedScene, main_node: Node) -> void:
	# Create the new level instance
	var new_level = new_level_scene.instantiate()
	new_level.name = "Level"
	
	# Wait a few frames to let the engine catch up
	for i in range(3):
		await get_tree().process_frame
	
	# Add the level to the scene
	main_node.add_child(new_level)
	
	# Give time for the level to initialize
	for i in range(5):
		await get_tree().process_frame

func load_final_level(main_node: Node) -> void:
	var end_screen = main_node.get_node("Winner")
	ui.hide()
	end_screen.show()
	final_score_label.text = "High Score: " + str(score)
	score = 0
	lives = 3
	label.text = "Score: " + str(score)
	
	if ResourcePaths.loaded_resources.has("res://assets/music/winner.mp3"):
		AudioManager.background_music.stream = ResourcePaths.loaded_resources["res://assets/music/winner.mp3"] as AudioStream
		AudioManager.background_music.play()
	else:
		push_warning("GameManager: 'winner.mp3' not found in loaded_resources.")
