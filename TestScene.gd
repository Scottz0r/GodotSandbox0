extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$DialogNode.connect("dialog_close", $Player, "set_active")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
