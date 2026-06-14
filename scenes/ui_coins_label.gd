extends Label


func _ready() -> void:
	text = "Coins: 0"
	Sigs.coin_value_updated.connect(on_coins_value_updated)

func on_coins_value_updated():
	print("here")
	text = "Coins " + str(Vars.coins)
	
