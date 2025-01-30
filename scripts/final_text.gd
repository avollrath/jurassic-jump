# final_text.gd
extends Label

# This is the text we’ll animate. You can also pass it from outside.
var final_text: String = """
Thank you for playing Jurassic Jump. 
You now belong to the elite circle of just a few people in the whole world who have finished this game.

If you enjoyed the challenge, tell your friends about it and send me a message with your highscore on my website:
vollrath.dev

Thanks and stay non-extinct,

André
"""

# Flag to ensure the animation runs only once
var animation_started: bool = false

# Optional: Add an AudioStreamPlayer for typing sounds
# Ensure you have a child node named "TypeSound" with an assigned sound
@onready var type_sound: AudioStreamPlayer = $"../../TypeSound"

func _ready() -> void:
	# Clear any existing text
	text = ""
	visible_characters = 0
	
	# Connect to the visibility_changed signal correctly
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if self.visible and not animation_started:
		animation_started = true
		# Start the scroll_text as an async function
		scroll_text(final_text)

# Declare scroll_text as an async function since it uses await
func scroll_text(input_text: String) -> void:
	# Set the Label's text all at once
	text = input_text
	visible_characters = 0
	
	# Animation settings
	var characters_per_second: float = 30.0  # Adjust for typing speed
	var interval: float = 1.0 / characters_per_second
	
	# Start the typewriter effect
	for i in range(text.length()):
		visible_characters = i + 1
		if type_sound:
			type_sound.play()
		await get_tree().create_timer(interval).timeout
