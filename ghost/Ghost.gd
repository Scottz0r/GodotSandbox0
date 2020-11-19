extends Node2D

var going_down = true

export(int) var float_speed = 10
export(int) var float_distance = 5

func _ready():
	pass

func _process(delta):
	if going_down:
		if $Sprite.offset.y > float_distance:
			going_down = false
		else:
			$Sprite.offset.y += float_speed * delta
	else:
		if $Sprite.offset.y < 0:
			going_down = true
		else:
			$Sprite.offset.y -= float_speed * delta
