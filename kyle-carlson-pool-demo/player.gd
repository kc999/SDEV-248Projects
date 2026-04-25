extends CharacterBody3D
var playerInput: Vector2
@export var speed: float = 2.5
func _unhandled_input(event: InputEvent) -> void:
	playerInput = Input.get_vector("left","right","forward","backward")
	
func _physics_process(delta: float) -> void:
	playerInput = playerInput.normalized()
	velocity = Vector3(playerInput.x*speed,0,playerInput.y* speed)
	move_and_slide()
