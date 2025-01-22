extends Node

@onready var background_music: AudioStreamPlayer = $Music/BackgroundMusic

@onready var bounce_sound: AudioStreamPlayer = $SFX/BounceSound
@onready var coin_sound: AudioStreamPlayer = $SFX/CoinSound
@onready var fight_sound: AudioStreamPlayer = $SFX/FightSound
@onready var jump_sound: AudioStreamPlayer = $SFX/JumpSound
@onready var win_sound: AudioStreamPlayer = $SFX/WinSound
@onready var die_sound: AudioStreamPlayer = $SFX/DieSound
@onready var damage_sound: AudioStreamPlayer = $SFX/DamageSound
@onready var land_sound: AudioStreamPlayer = $SFX/LandSound

@onready var game_over_music: AudioStreamPlayer = $Music/GameOverMusic
