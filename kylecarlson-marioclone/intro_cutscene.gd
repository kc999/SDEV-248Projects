extends Node2D

@onready var pathFollow: PathFollow2D = $Path2D/PathFollow2D

func _process(delta: float) -> void:
	pathFollow.progress += 8 * delta

func _on_game_start_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file","res://level_1.tscn")
