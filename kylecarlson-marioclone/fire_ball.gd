extends CharacterBody2D

var dir: Vector2 = Vector2.RIGHT
var speed: float = 350
var grav: float = 600
var jumpHeight: float = 75
@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	velocity.x = speed * dir.x
	if !is_on_floor():
		velocity.y += grav * delta
	if is_on_floor():
		velocity.y =- jumpHeight
	move_and_slide()
	
	if is_on_wall():
		queue_free()		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.fireBallHit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
