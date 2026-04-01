extends CharacterBody2D

var speed: float = 50
var direction: Vector2 = Vector2.RIGHT
const GRAVITY = 500

func _physics_process(delta: float) -> void:
		if is_on_wall():
			direction.x = -direction.x
		velocity.x = direction.x * speed
		if !is_on_floor():
			velocity.y += delta * GRAVITY
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.currentState == body.playerState.NORMAL:
			body.enlarge()
		queue_free()
	
