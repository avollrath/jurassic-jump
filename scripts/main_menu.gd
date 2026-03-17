extends Node

@onready var ui: CanvasLayer             = $"/root/main/UI"
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
		if not is_instance_valid(level_instance):
			# Pre-instantiate the first level so we can render it during startup warmup.
			level_instance = packed_scene.instantiate()
			level_instance.name = "Level"
			var main_root := get_node("/root/main")
			main_root.add_child(level_instance)
			main_root.move_child(level_instance, 0)

		_set_level_active_for_menu_warmup()
	else:
		push_warning("MainMenu: Could not find Level1 in ResourcePaths.loaded_resources!")
		packed_scene = null

func _on_start_button_pressed() -> void:
	background_image.hide()
	ui.show()
	if is_instance_valid(level_instance) and level_instance.is_inside_tree():
		_activate_preloaded_level_for_gameplay()
	else:
		GameManager.load_new_level(packed_scene)
	main_menu.hide()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func freeze_preloaded_level() -> void:
	if is_instance_valid(level_instance) and level_instance.is_inside_tree():
		_set_camera_enabled(level_instance, false)
		level_instance.process_mode = Node.PROCESS_MODE_DISABLED
		level_instance.visible = false

func _set_level_active_for_menu_warmup() -> void:
	if is_instance_valid(level_instance) and level_instance.is_inside_tree():
		level_instance.process_mode = Node.PROCESS_MODE_INHERIT
		level_instance.visible = true
		_set_camera_enabled(level_instance, false)

func _activate_preloaded_level_for_gameplay() -> void:
	if is_instance_valid(level_instance) and level_instance.is_inside_tree():
		level_instance.process_mode = Node.PROCESS_MODE_INHERIT
		level_instance.visible = true
		_set_camera_enabled(level_instance, true)

func _set_camera_enabled(node: Node, enabled: bool) -> void:
	if node is Camera2D:
		node.enabled = enabled

	for child in node.get_children():
		_set_camera_enabled(child, enabled)
