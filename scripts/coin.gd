extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	GameManager.add_points(10)
	AudioManager.coin_sound.play()
	animation_player.play("pickup")
