extends Node2D

@onready var particles: GPUParticles2D = $Particles
@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape: CollisionShape2D = $StaticBody2D/CollisionShape2D
func _on_area_2d_area_entered(area: Area2D) -> void:
	#Make sure the player isnt falling when the collision happens
	var player = area.owner
	if area.get_collision_layer_value(5) && (player.velocity.y < 0 || player.velocity.y == 0):
		sprite.visible = false
		collisionShape.set_deferred("disabled", true)
		particles.emitting = true

func _on_particles_finished() -> void:
	queue_free()
