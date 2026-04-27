extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Poolballs") || body.is_in_group("Cueball"):
		Ui.display_message("Ball out of bounds! Resetting...")
		body.returntotable
