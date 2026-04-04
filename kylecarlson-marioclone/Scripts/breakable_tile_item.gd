extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var disableTimer: Timer = $AnimationPlayer/DisableTimer
@export var coin: PackedScene
@export var life: PackedScene

@export var isCoinBlock: bool = false
@export var isLifeBlock: bool = false
var active: bool = true
var root

func _ready() -> void:
	root = get_tree().root

func _on_area_2d_area_entered(area: Area2D) -> void:
	#Make sure the player isnt falling when the collision happens
	var player = area.owner
	if area.get_collision_layer_value(5) && (player.velocity.y <= 0) && active == true:
		animPlayer.play("hit")
		if isCoinBlock && coin:
			var newCoin = coin.instantiate()
			root.add_child(newCoin)
			newCoin.global_position = global_position
		if isLifeBlock && life:
			var newLife = life.instantiate()
			root.add_child(newLife)
			newLife.global_position = global_position
