extends CharacterBody2D

var speed: float = 50
var direction: Vector2 = Vector2.RIGHT
const GRAVITY = 500
var active: bool = false
@onready var animPlayer = $AnimPlayer
@onready var collideShape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
		if active:
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
	

func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	collideShape.set_deferred("disabled", false)
	active = true
