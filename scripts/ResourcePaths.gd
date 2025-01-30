extends Node

var resources_to_load := [
	# -------------------------------------------------
	# FONTS
	# -------------------------------------------------
	"res://assets/fonts/Gorditas-Bold.ttf",
	"res://assets/fonts/Gorditas-Regular.ttf",

	# -------------------------------------------------
	# MUSIC
	# -------------------------------------------------
	"res://assets/music/backgroundMusic1.mp3",
	"res://assets/music/backgroundMusic2.mp3",
	"res://assets/music/backgroundMusic3.mp3",
	"res://assets/music/gameover.mp3",
	"res://assets/music/winner.mp3",

	# -------------------------------------------------
	# SOUNDS
	# -------------------------------------------------
	"res://assets/sounds/bounce.mp3",
	"res://assets/sounds/coin.mp3",
	"res://assets/sounds/damage.mp3",
	"res://assets/sounds/die.mp3",
	"res://assets/sounds/fight.mp3",
	"res://assets/sounds/jump.mp3",
	"res://assets/sounds/land.mp3",
	"res://assets/sounds/rizz-sound-effect.mp3",
	"res://assets/sounds/snail.mp3",
	"res://assets/sounds/spikey.mp3",
	"res://assets/sounds/walk.mp3",
	"res://assets/sounds/win.mp3",
	"res://assets/sounds/fall.mp3",

	# -------------------------------------------------
	# SPRITES (only .png/.jpg/.webp, skipping .import)
	# -------------------------------------------------
	"res://assets/sprites/background1.jpg",
	"res://assets/sprites/background2.jpg",
	"res://assets/sprites/background3.jpg",
	"res://assets/sprites/bg_ref.jpg",
	"res://assets/sprites/big_platform.png",
	"res://assets/sprites/char_sprite.png",
	"res://assets/sprites/cloud.png",
	"res://assets/sprites/coin_sprite.png",
	"res://assets/sprites/finish.png",
	"res://assets/sprites/finish_particles_sprite.png",
	"res://assets/sprites/fire_sprite.png",
	"res://assets/sprites/foreground1.png",
	"res://assets/sprites/foreground1_blur.png",
	"res://assets/sprites/frame.png",
	"res://assets/sprites/game_over.jpg",
	"res://assets/sprites/game_over.webp",
	"res://assets/sprites/ground.png",
	"res://assets/sprites/leaf.png",
	"res://assets/sprites/life.png",
	"res://assets/sprites/logo.png",
	"res://assets/sprites/menu_frame.png",
	"res://assets/sprites/mushroom_sprite.png",
	"res://assets/sprites/pillar.png",
	"res://assets/sprites/platform.png",
	"res://assets/sprites/rex-skeleton.png",
	"res://assets/sprites/snail_sprite.png",
	"res://assets/sprites/spikey_sprite.png",
	"res://assets/sprites/tree.png",
	"res://assets/sprites/loading_spinner.png",

	# Example of “blurred assets” subfolder:
	"res://assets/sprites/blurred assets/background1.jpg",
	"res://assets/sprites/blurred assets/background2.jpg",
	"res://assets/sprites/blurred assets/background3.jpg",
	"res://assets/sprites/blurred assets/cloud.png",
	"res://assets/sprites/blurred assets/menu_background.jpg",
	"res://assets/sprites/blurred assets/menu_background2.jpg",
	"res://assets/sprites/blurred assets/foreground1.png",
	"res://assets/sprites/blurred assets/pillar.png",
	"res://assets/sprites/blurred assets/rex-skeleton.png",
	"res://assets/sprites/blurred assets/tree.png",
	# ...and so on (only .jpg/.png/.webp files).

	# Example of “Particles” subfolder (only actual image files):
	"res://assets/sprites/Particles/circle_01.png",
	"res://assets/sprites/Particles/circle_02.png",
	"res://assets/sprites/Particles/circle_03.png",
	# etc...
	"res://assets/sprites/Particles/light_01.png",
	"res://assets/sprites/Particles/light_02.png",
	# ...
	"res://assets/sprites/Particles/smoke_10.png",
	"res://assets/sprites/Particles/spark_07.png",
	"res://assets/sprites/Particles/star_09.png",
	# ...
	# same for any additional .png or .jpg in that folder
	# (omit .import and .txt files).

	# -------------------------------------------------
	# SCENES (.tscn)
	# -------------------------------------------------
	"res://scenes/audio_manager.tscn",
	"res://scenes/cloud.tscn",
	"res://scenes/coin.tscn",
	"res://scenes/enemy.tscn",
	"res://scenes/finish.tscn",
	"res://scenes/game_manager.tscn",
	"res://scenes/game_over.tscn",
	"res://scenes/ground.tscn",
	"res://scenes/high_platform.tscn",
	"res://scenes/killzone.tscn",
	"res://scenes/level1.tscn",
	"res://scenes/level2.tscn",
	"res://scenes/level3.tscn",
	"res://scenes/loading_screen.tscn",
	"res://scenes/main.tscn",
	"res://scenes/main_menu.tscn",
	"res://scenes/mushroom.tscn",
	"res://scenes/platform.tscn",
	"res://scenes/player.tscn",
	"res://scenes/spikey_enemy.tscn",
	"res://scenes/ui.tscn",

	# -------------------------------------------------
	# SCRIPTS (.gd, .tres, .gdshader)
	# -------------------------------------------------
	"res://scripts/audio_manager.gd",
	"res://scripts/cloud.gd",
	"res://scripts/coin.gd",
	"res://scripts/enemy.gd",
	"res://scripts/finish.gd",
	"res://scripts/game_manager.gd",
	"res://scripts/game_over.gd",
	"res://scripts/killzone.gd",
	"res://scripts/main.gd",
	"res://scripts/main_menu.gd",
	"res://scripts/mushroom.gd",
	"res://scripts/player.gd",
	"res://scripts/ui.gd",
	"res://scripts/ui_theme.tres",
	"res://scripts/shaders/blur.gdshader"
]

# We will store the actual Resource objects once loaded:
var loaded_resources: = {}
