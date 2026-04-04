extends CanvasLayer

@onready var coinsLabel: Label = $CoinsLabel
@onready var livesLabel: Label = $Lives

var coins: int = 0
var lives: int = 0

func add_coin(coin_to_add: int) -> void:
	coins += coin_to_add
	update_coins()

func remove_lives(lives_to_remove: int) -> void:
	lives -= lives_to_remove
	update_lives()
func add_lives(lives_to_add: int) -> void:
	lives += lives_to_add
	update_lives()

func update_coins() -> void:
	coinsLabel.text = "Coins: " + str(coins)

func update_lives() -> void:
	livesLabel.text = str(lives)
