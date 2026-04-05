extends Node2D

var UI

func _ready() -> void:
	UI = get_tree().get_first_node_in_group("ui")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		UI.add_coin(1)
		queue_free()
