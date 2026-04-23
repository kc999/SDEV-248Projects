extends CharacterBody2D

const GRAVITY = 500
var movementVec : Vector2
var horV: float = 0
var speed: float = 170
var accelSpeed: float = 10
var fric: float = 15
var endingRestrict: bool = false
enum playerState {NORMAL,LARGE,FLOWER,HURT,DEAD,ENDING}
var currentState = playerState.NORMAL
var invulnerable: bool = false
var firing: bool = false
var canShoot: bool = true
var normColor = Color("#ffffff")
var fireColor = Color("#de7331")
var root
@export var jumpHeight: float = 300
@export var jumpReleaseMultiplier: float = 0.5
@export var fireBallScene: PackedScene
@onready var unFireTimer: Timer = $unFireTimer
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var playerCollision = $CollisionShape2D
@onready var playerHeadCollision = $Area2D/CollisionShape2D
@onready var animPlayer: AnimationPlayer = $AnimPlayer
@onready var fireTimer: Timer = $fireTimer
@onready var fireRateTimer: Timer = $fireRateTimer
@onready var characterCollision: CollisionShape2D = $CollisionShape2D
@onready var deathTimer: Timer = $DeathTimer
var UI: CanvasLayer
func _ready() -> void:
	root = get_tree().root
	UI = get_tree().get_first_node_in_group("ui")

#Get movement
func _unhandled_input(event: InputEvent) -> void:
	movementVec = Input.get_vector("left","right","jump","crouch")
	
func _physics_process(delta: float) -> void:
	if currentState != playerState.DEAD && currentState != playerState.ENDING:
		playerMovement(movementVec, delta)
		shoot_fireball()
	elif currentState == playerState.DEAD:
		dead(delta)
	elif currentState == playerState.ENDING:
		ending(delta)
	
func playerMovement(moveVec: Vector2, delta) -> void:
	#Get Horizontal Movement
	#If player is moving
	if is_on_floor():
		#If the player is holding down the mpovement keys
		if movementVec.x != 0:
			horV = lerp(horV, movementVec.x * speed, accelSpeed * delta)
			if !firing:
				sprite.play("walk")
			sprite.flip_h = true if sign(horV) == -1 else false
		if movementVec.x == 0:
			horV = lerp(horV, movementVec.x * speed, fric * delta)
			if !firing:
				sprite.play("idle")
		#Jump
		if Input.is_action_pressed("jump"):
			velocity.y -= jumpHeight
			if !firing:
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
	

func enlarge()-> void:
	animPlayer.play("grow")
	invulnerable = true

func shrink() -> void:
	print("shrinking")
	animPlayer.play_backwards("grow")
	invulnerable = true
	
func take_damage()-> void:
	if !invulnerable:
		if currentState == playerState.NORMAL:
			die()
		if currentState == playerState.LARGE:
			shrink()
		if currentState == playerState.FLOWER:
			unFireTimer.start()
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
	currentState = playerState.FLOWER
	invulnerable = false
	

func shoot_fireball() -> void:
	if currentState == playerState.FLOWER && canShoot:
		if Input.is_action_pressed("attack"):
			var fireBall = fireBallScene.instantiate()
			root.add_child(fireBall)
			fireBall.global_position = global_position
			fireBall.dir.x = -1 if sprite.flip_h == true else 1
			firing = true
			canShoot = false
			fireRateTimer.start()
			sprite.play("shoot")

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "shoot":
		firing = false

func _on_fire_rate_timer_timeout() -> void:
	canShoot = true


func _on_un_fire_timer_timeout() -> void:
	currentState = playerState.LARGE
	invulnerable = false
	change_color(normColor)

func die():
	currentState = playerState.DEAD
	velocity.x = 0
	velocity.y = -200
	characterCollision.set_deferred("disabled",true)
	sprite.play("dead")
	
	deathTimer.start()
	
func dead(delta):
	velocity.y += GRAVITY * delta
	move_and_slide()

func _on_death_timer_timeout() -> void:
	UI.remove_lives(1)
	#Restart game and remove lives
	if player_stats.lives > 0:
		get_tree().call_deferred("reload_current_scene")
	else:
		player_stats.lives = 3
		player_stats.coins = 0
		get_tree().call_deferred("change_scene_to_file","res://game_over.tscn")

func ending(delta):
	if !endingRestrict:
		#Move right
		velocity.x = Vector2.RIGHT.x * speed
		sprite.play("walk")
		if !is_on_floor():
			sprite.play("jump")
			velocity.y += GRAVITY * delta
		move_and_slide()
