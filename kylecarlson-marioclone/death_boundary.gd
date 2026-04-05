extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Instantly kill the player
		body.currentState = body.playerState.NORMAL
		body.take_damage()
