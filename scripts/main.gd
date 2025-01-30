extends Node2D

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

@onready var loading_screen: Control    = $LoadingScreen
@onready var progress_bar: ProgressBar  = $LoadingScreen/LoadingProgressBar
@onready var loading_label: Label        = $LoadingScreen/LoadingLabel
@onready var message_timer: Timer        = $LoadingScreen/MessageTimer
@onready var press_key: Label = $LoadingScreen/PressKey
@onready var main_menu: Control         = $MainMenu
@onready var bg_image: TextureRect        = $BackgroundImage

var total_resources = 0
var current_index = 0
var current_path = ""
var is_loading = false

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
	elif not is_loading && Input.is_anything_pressed() && loading_screen.visible:
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
	message_timer.stop()
	loading_screen.hide()
	AudioManager.init_resources()
	AudioManager.background_music.play()
	$MainMenu.init_resources()
	$BackgroundImage.show()
	$MainMenu.show()
