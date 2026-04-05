extends CharacterBody2D

var dir: Vector2 = Vector2.RIGHT
var speed: float = 200
var grav: float = 200
var jumpHeight: float = 75
@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	velocity.x = speed * dir.x
	if !is_on_floor():
		velocity.y += grav * delta
	if is_on_floor():
		velocity.y =- jumpHeight
	move_and_slide()
	
