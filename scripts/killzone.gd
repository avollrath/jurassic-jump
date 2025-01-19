extends Area2D

@onready var timer: Timer = $Timer
@onready var level: Node = get_parent() # Assumes this script is attached to Killzone, and Level1 is its parent.
@onready var player: CharacterBody2D = null
@onready var spawn_point: Marker2D = $"../Level/SpawnPoint"

func _on_body_entered(body: Node2D) -> void:
	player = body
	GameManager.decrease_health()
	timer.start()

func _on_timer_timeout() -> void:
	respawn_player()

func respawn_player() -> void:
	if player and spawn_point:
		player.global_position = spawn_point.global_position
		player.velocity.x = 0
		player.velocity.y = 0
		var sprite = player.get_node("AnimatedSprite2D")
		if sprite:
			sprite.flip_h = false
