extends CharacterBody3D
var playerInput: Vector2
@export var speed: float = 1
@export var speedSlowed: float = 0.25
var speedDefault = speed
var movementLocked: bool = false
var mouseMovement: Vector2 
@export var sensitivity: float = 0.005
@export var sensitivitySlowed: float = 0.0025
var sensitivityDef: float = sensitivity
var force: float = .1
@onready var rayCast: RayCast3D = $CueHolder/poolcue/PoolCue/HitDetection
@onready var animPlayer: AnimationPlayer = $CueHolder/AnimPlayer
var hit: bool = false
var waitingForHit: bool = false
var charging: bool = false
func _unhandled_input(event: InputEvent) -> void:
	playerInput = Input.get_vector("left","right","forward","backward")
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate"):
			rotate_y(-event.relative.x * sensitivity)
	if Input.is_action_pressed("shoot") && !animPlayer.is_playing() && !charging:
		force = 0.1
		animPlayer.play("PullBack")
	if Input.is_action_pressed("slowdown"):
		speed = speedSlowed
		sensitivity = sensitivitySlowed
	else:
		speed = speedDefault
		sensitivity = sensitivityDef
func _physics_process(delta: float) -> void:
	playerInput = playerInput.normalized()
	var moveVec = global_basis * Vector3(playerInput.x*speed,0,playerInput.y* speed)
	velocity =  moveVec
	if Input.is_action_pressed("down"):
		velocity.y = -speed/2
	if Input.is_action_pressed("up"):
		velocity.y = speed/2
	move_and_slide()
	if charging:
		charge_shot(delta)
	if waitingForHit:
		hit_ball()

func hit_ball() -> void:
	rayCast.enabled = true
	if rayCast.is_colliding():
		var hit = rayCast.get_collider()
		var collidePoint = rayCast.get_collision_point()
		
		if hit is RigidBody3D:
			#Hit
			var forwardPush = global_basis * Vector3.FORWARD
			hit.apply_impulse(forwardPush * force, hit.global_position - collidePoint)
			waitingForHit = false

func set_waiting_for_hit_true() -> void:
	waitingForHit = true
func set_waiting_for_hit_false() -> void:
	waitingForHit = false
func charge_shot(delta):
	if Input.is_action_pressed("shoot"):
		force += .8 * delta
		Ui.updateShotPower(force)
		force = clamp(force,0.1,.8)
		print(force)
	if !Input.is_action_pressed("shoot"):
		Ui.shotsTaken += 1
		Ui.update_shots()
		animPlayer.play("Shoot")
		Ui.updateShotPower(0)
		
		charging = false

func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PullBack":
		charging = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
