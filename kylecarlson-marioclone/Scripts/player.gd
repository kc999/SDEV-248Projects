extends CharacterBody2D

const GRAVITY = 500
var movementVec : Vector2
var horV: float = 0
var speed: float = 170
var accelSpeed: float = 10
var fric: float = 15
enum playerState {NORMAL,LARGE,FLOWER,HURT,DEAD}
var currentState = playerState.NORMAL
var invulnerable: bool = false
var normColor = Color("#ffffff")
var fireColor = Color("#de7331")
@export var jumpHeight: float = 300
@export var jumpReleaseMultiplier: float = 0.5
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var playerCollision = $CollisionShape2D
@onready var playerHeadCollision = $Area2D/CollisionShape2D
@onready var animPlayer: AnimationPlayer = $AnimPlayer
@onready var fireTimer: Timer = $fireTimer
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
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y *= jumpReleaseMultiplier
		velocity.x += movementVec.x * speed * delta
		if abs(velocity.x) > speed:
			velocity.x = speed * sign(velocity.x)
		velocity.y += delta * GRAVITY
	if !invulnerable: 
		move_and_slide()
	
func controlSize(state)-> void:
	match state:
		playerState.NORMAL:
			sprite.scale = Vector2(1,1)
		playerState.LARGE:
			sprite.scale = Vector2(1.5,1.5)
			playerCollision.scale = Vector2(1.25,1.25)
			playerHeadCollision.position.y = -39 
		playerState.FLOWER:
			sprite.scale = Vector2(0.75,0.75)
		_:
			sprite.scale = Vector2(0.4,0.4)

func enlarge()-> void:
	animPlayer.play("grow")
	invulnerable = true

func shrink() -> void:
	print("shrinking")
	animPlayer.play_backwards("grow")
	invulnerable = true
	
func take_damage()-> void:
	print(currentState)
	if !invulnerable:
		if currentState == playerState.LARGE:
			shrink()
		if currentState == playerState.FLOWER:
			change_color(normColor)
			fireTimer.start()
			invulnerable = true
func change_color(color:Color)-> void:
	sprite.modulate = color
	
func pickup_flower() -> void:
	if currentState == playerState.LARGE:
		fireTimer.start()
		change_color(fireColor)
		invulnerable = true
	elif currentState == playerState.NORMAL:
		enlarge()
func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "grow":
		invulnerable = false
		if currentState == playerState.NORMAL:
			currentState = playerState.LARGE
			return
		if currentState == playerState.LARGE:
			currentState = playerState.NORMAL
			return
		
func _on_fire_timer_timeout() -> void:
	#Chose the correct state based on what state the player has when this function is called
	if currentState == playerState.FLOWER:
		#Player has a flower, make them normal again
		currentState  = playerState.LARGE
		invulnerable = false
	#Player is in large state, make them have a flower now
	if currentState == playerState.LARGE:
		currentState = playerState.FLOWER
		invulnerable = false
