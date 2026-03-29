extends CharacterBody2D

var speed: float = 50
var direction: Vector2 = Vector2.LEFT
const GRAVITY = 500
var dead: bool = false
@export var active: bool = false
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var collisionShape1: CollisionShape2D = $CollisionShape2D
@onready var collisionShape2: CollisionShape2D = $HeadHitbox/CollisionShape2D
func _physics_process(delta: float) -> void:
	if active && !dead:
		if is_on_wall():
			direction.x = -direction.x
		velocity.x = direction.x * speed
		if !is_on_floor():
			velocity.y += delta * GRAVITY
		move_and_slide()
	
func _on_head_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.currentState != body.playerState.DEAD:
			body.velocity.y = -body.jumpHeight
			dead = true
			die()

func die() -> void:
	animPlayer.play("die")
	
	collisionShape1.set_deferred("disabled",true)
	collisionShape2.set_deferred("disabled",true)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
