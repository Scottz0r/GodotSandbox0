extends Node2D


func _ready():
	$Coin1.connect("pickup", $LizardPlayer, "pickup_object")
	$CoinPlaceholder1.connect("dont_have_item", self, "_dont_have_coin1")
	$CoinPlaceholder1.connect("item_taken", self, "_coin1_taken")


func _dont_have_coin1(item):
	print("Hey! You need a coin for this spot.")


func _coin1_taken(item):
	print("Good. You placed the coin.")
	$LizardPlayer.remove_item("coin")
	$CoinPlaceholder1.fulfill()
