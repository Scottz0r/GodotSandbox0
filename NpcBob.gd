extends Area2D

var is_talking = false

signal talking

func talk():
	# TODO: This should probalby be in a signal or make dialog a singleton?
	var dialog = get_tree().root.get_node("Node/DialogNode")
	if not is_talking:
		is_talking = true
		dialog.npc = self
		dialog.dialog = "Hello. I'm bob. I'm talking."
		dialog.open()
	else:
		is_talking = false
		dialog.close()
