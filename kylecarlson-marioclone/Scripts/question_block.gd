extends Node2D

var dudSprite = preload("res://Assets/Sprites/World/dudblock.png")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var playerCollide: Area2D = $PlayerCollide
@export var containsCoin: bool = false
@export var containsMushroom: bool = false
@export var coinScene: PackedScene
func turn_to_dud() -> void:
	sprite.texture = dudSprite
func _on_player_collide_area_entered(area: Area2D) -> void:
	var player = area.owner
	if area.get_collision_layer_value(5) && (player.velocity.y < 0 || player.velocity.y == 0):
		animPlayer.play("hit")
		playerCollide.set_deferred("monitoring",false)
		if containsCoin && coinScene:
			var coin = coinScene.instantiate()
			var root = get_tree().root
			root.add_child(coin)
			coin.global_position = global_position
			print(coin.global_position)
			
			
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	turn_to_dud()
	
