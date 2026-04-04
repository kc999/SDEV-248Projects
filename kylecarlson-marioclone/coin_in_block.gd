extends Node2D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hit":
		var UI = get_tree().get_first_node_in_group("ui")
		if UI:
			UI.add_coin(1)
		queue_free()
