extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Cueball"):
		body.returnToTable = true
		Ui.display_message("Scratch! Try Again!")
	if body.is_in_group("Poolballs"):
		body.call_deferred("queue_free")
		Ui.shotsMadeAmount += 1
		Ui.update_shots_made()
