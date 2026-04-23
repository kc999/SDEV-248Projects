extends Node2D

var fall: bool = false
var flagFinished: bool = false
var flagSpeed: float = 100
@export var playerCollided: bool = false
@onready var flagSprite = $Flag
@onready var endGameTimer: Timer = $EndGameTimer
@onready var flagPolePlayerCollide = $FlagPolePlayerCollide/CollisionShape2D
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta: float) -> void:
	if (playerCollided && fall == false):
		fall = true

	if (fall == true && flagFinished == false):
		flagSprite.position.y += flagSpeed * delta
	
	if flagFinished == true:
		endGameTimer.start()
		player.endingRestrict = false
		player.velocity.y = -200
		var UI = get_tree().get_first_node_in_group("ui")
		if player_stats.coins >= 20:
			UI.winMsg.visible = true
		else:
			UI.loseMsg.visible = true
		flagFinished = false
		


func _on_flag_collide_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(8):
		playerCollided = false
		fall = false
		flagFinished = true


func _on_flag_pole_player_collide_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerCollided = true
		player.currentState = player.playerState.ENDING
		player.endingRestrict = true
		flagPolePlayerCollide.set_deferred("disabled",true)
		

func _on_end_game_timer_timeout() -> void:
	player_stats.coins = 0
	player_stats.lives = 3
	get_tree().call_deferred("change_scene_to_file","res://main_menu.tscn")
