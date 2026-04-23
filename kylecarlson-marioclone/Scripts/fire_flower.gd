extends Area2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position:y",position.y - 16,0.2).set_trans(Tween.TRANS_LINEAR)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pickup_flower()
		queue_free()
