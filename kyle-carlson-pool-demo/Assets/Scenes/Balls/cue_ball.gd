extends RigidBody3D
var defaultPos: Vector3 
var returnToTable: bool = false
func _ready() -> void:
	defaultPos = global_position

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if returnToTable:
		var newTransform = state.transform
		newTransform.origin = defaultPos
		state.transform = newTransform
		
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		print("teleported")
		returnToTable = false

	
