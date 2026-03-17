extends Node

var messages = [
	"Digging up dinosaurs...",
	"Brushing off fossils...",
	"Assembling the T-Rex...",
	"Searching for triceratops footprints...",
	"Feeding the velociraptors...",
	"Calibrating the time machine...",
	"Polishing dinosaur bones...",
	"Adjusting the pterodactyl wings...",
	"Mixing lava for volcano effects...",
	"Sharpening prehistoric tools..."
]

@onready var screen_layer: CanvasLayer   = $ScreenLayer
@onready var loading_screen: Control     = $ScreenLayer/LoadingScreen
@onready var progress_bar: ProgressBar   = $ScreenLayer/LoadingScreen/LoadingProgressBar
@onready var loading_label: Label        = $ScreenLayer/LoadingScreen/LoadingLabel
@onready var message_timer: Timer        = $ScreenLayer/LoadingScreen/MessageTimer
@onready var press_key: Label            = $ScreenLayer/LoadingScreen/PressKey
@onready var main_menu: Control          = $ScreenLayer/MainMenu
@onready var bg_image: TextureRect       = $ScreenLayer/BackgroundImage

var total_resources = 0
var current_index = 0
var current_path = ""
var is_loading = false
var is_starting = false
var startup_warmup_complete = false

func _ready() -> void:
	# We start with the loading screen visible
	loading_screen.show()
	main_menu.hide()
	bg_image.hide()

	# Randomize the RNG so we don't always pick the same message order
	randomize()

	message_timer.timeout.connect(_on_message_timer_timeout)
	# (Or do this in the editor's Signals tab)
	message_timer.start()

	# Start loading everything
	load_next_resource()
	
func _on_message_timer_timeout() -> void:
	# Pick a random message from the array
	var idx = randi() % messages.size()
	loading_label.text = messages[idx]

func load_next_resource() -> void:
	var resource_list = ResourcePaths.resources_to_load
	total_resources = resource_list.size()

	# If we have loaded everything, finalize
	if current_index >= total_resources:
		finish_loading()
		return

	current_path = resource_list[current_index]
	# Start a threaded load request for the current resource
	ResourceLoader.load_threaded_request(current_path)
	is_loading = true

func _process(_delta: float) -> void:
	if is_loading:
		update_progress()
	elif not is_loading && not is_starting && Input.is_anything_pressed() && loading_screen.visible:
		# Only handle key press if we're still on the loading screen
		start_game()
		

func update_progress() -> void:
	# Poll the status of the current resource load
	var progress_array = []
	var _status = ResourceLoader.load_threaded_get_status(current_path, progress_array)
	# progress_array[0] = fraction from 0.0 -> 1.0 for the *current* resource
	if progress_array.size() > 0:
		var per_resource_progress = progress_array[0]

		# Convert to the overall progress across *all* resources
		# e.g. (loaded_count + fraction_of_current) / total
		var overall_progress = (current_index + per_resource_progress) / float(total_resources)
		progress_bar.value = overall_progress * 100

		# Once the current resource is fully loaded, retrieve it and move on
		if per_resource_progress == 1.0:
			var loaded_res = ResourceLoader.load_threaded_get(current_path)
			if loaded_res:
				# Store it in our ResourcePaths.loaded_resources dict
				ResourcePaths.loaded_resources[current_path] = loaded_res
			else:
				push_warning("Failed to load resource at: " + current_path)

			# Done with current resource → move to the next
			current_index += 1
			is_loading = false
			load_next_resource()

func finish_loading() -> void:
	loading_label.hide()
	progress_bar.hide()
	press_key.show()
	
func start_game() -> void:
	if is_starting:
		return

	is_starting = true
	message_timer.stop()

	if not startup_warmup_complete:
		loading_label.show()
		loading_label.text = "Warming up graphics..."
		press_key.hide()
		await $ScreenLayer/MainMenu.init_resources()
		await _warm_up_graphics()
		$ScreenLayer/MainMenu.freeze_preloaded_level()
		_reset_viewport_canvas()
		startup_warmup_complete = true

	loading_screen.hide()
	_reset_viewport_canvas()
	AudioManager.init_resources()
	AudioManager.background_music.play()
	$ScreenLayer/BackgroundImage.show()
	$ScreenLayer/MainMenu.show()
	is_starting = false

func _warm_up_graphics() -> void:
	var warmup_root := Node2D.new()
	warmup_root.name = "WarmupRoot"
	warmup_root.z_index = -1000
	add_child(warmup_root)
	move_child(warmup_root, 0)

	_add_warmup_scene(warmup_root, "res://scenes/player.tscn", Vector2(540, 700))
	_add_warmup_scene(warmup_root, "res://scenes/mushroom.tscn", Vector2(960, 700))
	_add_warmup_scene(warmup_root, "res://scenes/finish.tscn", Vector2(1380, 760))

	# Let the scene enter the tree before forcing emissions so WebGL has real draw work to compile.
	for i in range(2):
		await get_tree().process_frame

	_restart_particles_recursive(warmup_root)

	for i in range(12):
		await get_tree().process_frame

	warmup_root.queue_free()

func _reset_viewport_canvas() -> void:
	var viewport := get_viewport()
	if viewport:
		viewport.canvas_transform = Transform2D()

func _add_warmup_scene(parent: Node, scene_path: String, position: Vector2) -> void:
	var packed_scene := ResourcePaths.loaded_resources.get(scene_path) as PackedScene
	if packed_scene == null:
		return

	var instance := packed_scene.instantiate()
	parent.add_child(instance)

	if instance is Node2D:
		instance.position = position

	_prepare_warmup_instance(instance)

func _prepare_warmup_instance(instance: Node) -> void:
	var camera := instance.get_node_or_null("Camera2D") as Camera2D
	if camera:
		camera.enabled = false

	var fight_particles := instance.get_node_or_null("FightParticles") as GPUParticles2D
	if fight_particles:
		fight_particles.emitting = true

	var wheels_particles := instance.get_node_or_null("WheelsParticles") as GPUParticles2D
	if wheels_particles:
		wheels_particles.emitting = true

	var bounce_particles := instance.get_node_or_null("BounceParticles") as GPUParticles2D
	if bounce_particles:
		bounce_particles.emitting = true

	var bounce_particles_alt := instance.get_node_or_null("BounceParticles2") as GPUParticles2D
	if bounce_particles_alt:
		bounce_particles_alt.amount_ratio = 1.0
		bounce_particles_alt.emitting = true

	var glow_particles := instance.get_node_or_null("Glow") as GPUParticles2D
	if glow_particles:
		glow_particles.emitting = true

func _restart_particles_recursive(node: Node) -> void:
	for child in node.get_children():
		_restart_particles_recursive(child)

	if node is GPUParticles2D:
		node.restart()
