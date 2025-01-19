extends Node
@onready var ui: CanvasLayer = $"../UI"

func _ready() -> void:
	AudioManager.background_music.play()

func _on_start_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/level1.tscn")
	var new_scene: PackedScene = ResourceLoader.load("res://scenes/level1.tscn") # Gets the loaded scene, which is packed, so it'll have to be manually instantiated
	var new_node = new_scene.instantiate() # Instantiates a copy of the loaded scene
	#var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
	get_parent().add_child(new_node)
	ui.show()
	queue_free()
	#get_tree().current_scene = new_node # Assigns our new scene as the current scene
	#current_scene.queue_free() # Now we can remove the original scene
