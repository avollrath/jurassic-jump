extends Sprite2D

@export var speed: float = 50.0  # Speed at which the sprite moves to the left
@export var sway_amplitude: float = 10.0  # Amplitude of the swaying motion
@export var sway_frequency: float = 1.0  # Frequency of the swaying motion

var time_passed: float = 0.0  # Tracks time for the sine wave
var random_offset: float = 0.0  # Random offset for the swaying motion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate a random offset for the sine wave to make the sway unique
	random_offset = randf() * 2.0 * PI  # Random value between 0 and 2π

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the time passed
	time_passed += delta

	# Move the sprite to the left
	position.x -= speed * delta

	# Apply swaying motion (sinusoidal with random offset)
	position.y += sway_amplitude * sin(time_passed * sway_frequency * 2.0 * PI + random_offset) * delta
