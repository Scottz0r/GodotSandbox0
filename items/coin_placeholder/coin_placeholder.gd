extends Area2D

signal item_taken
signal dont_have_item

var is_fulfilled = false


func interact(item_type):
	# TODO: Would probably want an enumeration instead of a string.
	if item_type == "coin":
		emit_signal("item_taken", "coin")
	else:
		emit_signal("dont_have_item", "coin")


func fulfill():
	# Once this item is fulfilled, make it fully visible.
	is_fulfilled = true
	$Sprite.modulate.a = 1.0

	# TODO: Need some sort of visual indicator this is a placeholder and not
	# a regular coin.
	$SpriteCheck.visible = true
