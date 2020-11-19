extends Node2D


func _ready():
	$Coin1.connect("pickup", $LizardPlayer, "pickup_object")
