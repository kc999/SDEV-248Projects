extends CharacterBody2D

const GRAVITY = 500
var movementVec : Vector2
var horV: float = 0
var speed: float = 200
var accelSpeed: float = 10
var fric: float = 15
enum playerState {NORMAL,LARGE,FLOWER,HURT,DEAD}
var currentState = playerState.NORMAL
@export var jumpHeight: float = 300
@onready var sprite: AnimatedSprite2D = $Sprite

#Get movement
func _unhandled_input(event: InputEvent) -> void:
	movementVec = Input.get_vector("left","right","jump","crouch")
	
func _physics_process(delta: float) -> void:
	playerMovement(movementVec, delta)
	
func playerMovement(moveVec: Vector2, delta) -> void:
	#Get Horizontal Movement
	#If player is moving
	if is_on_floor():
		#If the player is holding down the mpovement keys
		if movementVec.x != 0:
			horV = lerp(horV, movementVec.x * speed, accelSpeed * delta)
			sprite.play("walk")
			sprite.flip_h = true if sign(horV) == -1 else false
		if movementVec.x == 0:
			horV = lerp(horV, movementVec.x * speed, fric * delta)
			sprite.play("idle")
		#Jump
		if Input.is_action_pressed("jump"):
			velocity.y -= jumpHeight
			sprite.play("jump")
		velocity.x = horV
	else:
		velocity.x += movementVec.x * speed * delta
		if abs(velocity.x) > speed:
			velocity.x = speed * sign(velocity.x)
		velocity.y += delta * GRAVITY
	move_and_slide()
	
	
	
