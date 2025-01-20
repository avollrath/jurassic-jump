extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var jump_boost_velocity: float = -2000.0
@onready var bounce_particles: GPUParticles2D = $BounceParticles2

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if body.global_position.y < global_position.y and body.velocity.y > 0:
			bounce_particles.amount_ratio = 1
			bounce_particles.lifetime = 1
			bounce_particles.preprocess = 0
			animated_sprite.frame  = 1
			AudioManager.bounce_sound.play()
			animated_sprite.play()
			body.jump(jump_boost_velocity)
		

func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.frame  = 0
	bounce_particles.amount_ratio = 0.1
	bounce_particles.lifetime = 3
