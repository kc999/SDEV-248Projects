extends CanvasLayer

@onready var coinsLabel: Label = $CoinsLabel
@onready var livesLabel: Label = $Lives
@onready var winMsg: Label = $EndingMessageWin
@onready var loseMsg: Label = $EndingMessageFail
var coins: int
var lives: int

func _ready() -> void:
	coins = player_stats.coins
	lives = player_stats.lives
	update_coins()
	update_lives()
func add_coin(coin_to_add: int) -> void:
	player_stats.coins += coin_to_add
	coins = player_stats.coins
	update_coins()

func remove_lives(lives_to_remove: int) -> void:
	player_stats.lives -= lives_to_remove
	lives = player_stats.lives
	update_lives()
func add_lives(lives_to_add: int) -> void:
	player_stats.lives += lives_to_add
	lives = player_stats.lives
	update_lives()

func update_coins() -> void:
	coinsLabel.text = "Coins: " + str(player_stats.coins)

func update_lives() -> void:
	livesLabel.text = "Lives: " + str(player_stats.lives)
