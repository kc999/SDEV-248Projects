extends CanvasLayer

@onready var alertsLabel: Label = $Control/AlertsLabel
@onready var shots: Label = $Control2/VBoxContainer/Shots
@onready var shotsMadeLabel: Label = $Control3/VBoxContainer/ShotsMadeAmount
@onready var progressBar: ProgressBar = $Control4/VBoxContainer/ProgressBar
var shotsMadeAmount: int = 0
var shotsTaken: int = 0
func display_message(message: String):
	alertsLabel.show()
	alertsLabel.text = message
	await get_tree().create_timer(3).timeout
	alertsLabel.hide()

func update_shots():
	shots.text = str(shotsTaken)
	
func update_shots_made():
	shotsMadeLabel.text = str(shotsMadeAmount)
	
func updateShotPower(shotPower: float):
	progressBar.value = shotPower
