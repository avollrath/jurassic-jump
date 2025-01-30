extends Node

@onready var ui: CanvasLayer             = $"../UI"
@onready var background_image: TextureRect = $"../BackgroundImage"
@onready var main_menu: Control          = $"."

var next_scene1_path = "res://scenes/level1.tscn"
var packed_scene: PackedScene
var level_instance: Node   # We'll store the instantiated level here

func _ready() -> void:
	# We'll do the actual instantiation in init_resources()
	pass

func init_resources() -> void:
	# AFTER ResourcePaths is fully loaded
	if ResourcePaths.loaded_resources.has(next_scene1_path):
		packed_scene = ResourcePaths.loaded_resources[next_scene1_path] as PackedScene
		# Pre‐instantiate the level right now
		level_instance = packed_scene.instantiate()
		level_instance.name = "Level1"
		
		# Hide it so it doesn't appear yet
		level_instance.visible = false
		
		# Add it under the same parent (likely "main")
		
	else:
		push_warning("MainMenu: Could not find Level1 in ResourcePaths.loaded_resources!")
		packed_scene = null

func _on_start_button_pressed() -> void:
	background_image.hide()
	ui.show()
	GameManager.load_new_level(packed_scene)
	main_menu.hide()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
