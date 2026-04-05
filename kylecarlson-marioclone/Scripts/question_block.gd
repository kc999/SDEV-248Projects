extends Node2D

var dudSprite = preload("res://Assets/Sprites/World/dudblock.png")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var playerCollide: Area2D = $PlayerCollide
@export var containsCoin: bool = false
@export var containsMushroom: bool = false
@export var containsFlower: bool = false
@export var coinScene: PackedScene
@export var mushroomScene: PackedScene
@export var flowerScene: PackedScene
var root
func _ready() -> void:
	root = get_parent()
func turn_to_dud() -> void:
	sprite.texture = dudSprite
func _on_player_collide_area_entered(area: Area2D) -> void:
	animPlayer.play("hit")
	var player = area.owner
	if area.get_collision_layer_value(5) && (player.velocity.y < 0 || player.velocity.y == 0):
		var glob_pos = position
		print(glob_pos)
		if containsCoin && coinScene:
			var coin = coinScene.instantiate()
			coin.position = position
			root.call_deferred("add_child",coin)
			
		elif containsMushroom && mushroomScene:
			var mush = mushroomScene.instantiate()
			mush.position = position
			root.call_deferred("add_child",mush)
		elif containsFlower && flowerScene:
			var flow = flowerScene.instantiate()
			flow.position = position
			root.call_deferred("add_child",flow)
			
		playerCollide.set_deferred("monitoring",false)
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	turn_to_dud()
	
