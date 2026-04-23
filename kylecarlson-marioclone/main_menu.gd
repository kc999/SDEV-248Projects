extends CanvasLayer



func _on_play_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file","res://intro_cutscene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
