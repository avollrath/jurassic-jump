extends Node

@onready var background_music: AudioStreamPlayer = $Music/BackgroundMusic
@onready var bounce_sound: AudioStreamPlayer    = $SFX/BounceSound
@onready var coin_sound: AudioStreamPlayer      = $SFX/CoinSound
@onready var fight_sound: AudioStreamPlayer     = $SFX/FightSound
@onready var jump_sound: AudioStreamPlayer      = $SFX/JumpSound
@onready var win_sound: AudioStreamPlayer       = $SFX/WinSound
@onready var die_sound: AudioStreamPlayer       = $SFX/DieSound
@onready var damage_sound: AudioStreamPlayer    = $SFX/DamageSound
@onready var land_sound: AudioStreamPlayer      = $SFX/LandSound
@onready var game_over_music: AudioStreamPlayer = $Music/GameOverMusic
@onready var winner_music: AudioStreamPlayer = $Music/WinnerMusic
@onready var fall_sound: AudioStreamPlayer = $SFX/FallSound

func _ready() -> void:
	# Do nothing here for resource loading
	pass

func init_resources() -> void:
	# Safe to call AFTER ResourcePaths is fully loaded
	# Assign each AudioStream
	background_music.stream = ResourcePaths.loaded_resources["res://assets/music/backgroundMusic1.mp3"] as AudioStream
	bounce_sound.stream     = ResourcePaths.loaded_resources["res://assets/sounds/bounce.mp3"] as AudioStream
	coin_sound.stream       = ResourcePaths.loaded_resources["res://assets/sounds/coin.mp3"] as AudioStream
	fight_sound.stream      = ResourcePaths.loaded_resources["res://assets/sounds/fight.mp3"] as AudioStream
	jump_sound.stream       = ResourcePaths.loaded_resources["res://assets/sounds/jump.mp3"] as AudioStream
	win_sound.stream        = ResourcePaths.loaded_resources["res://assets/sounds/win.mp3"] as AudioStream
	die_sound.stream        = ResourcePaths.loaded_resources["res://assets/sounds/die.mp3"] as AudioStream
	damage_sound.stream     = ResourcePaths.loaded_resources["res://assets/sounds/damage.mp3"] as AudioStream
	land_sound.stream       = ResourcePaths.loaded_resources["res://assets/sounds/land.mp3"] as AudioStream
	game_over_music.stream  = ResourcePaths.loaded_resources["res://assets/music/gameover.mp3"] as AudioStream
	winner_music.stream  = ResourcePaths.loaded_resources["res://assets/music/winner.mp3"] as AudioStream
	fall_sound.stream  = ResourcePaths.loaded_resources["res://assets/sounds/fall.mp3"] as AudioStream
