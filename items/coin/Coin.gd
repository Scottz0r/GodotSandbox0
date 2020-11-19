extends Node2D
class_name Coin

signal pickup

func interact():
	emit_signal("pickup", self)
	queue_free()
