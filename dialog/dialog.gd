extends CanvasLayer

var dialog setget dialog_set
var npc

func dialog_set(new_value):
	# Setter function for the dialogue variable.
	dialog = new_value
	$DialogPopup/ColorRect/Dialogue.text = new_value

func open():
	# Open and show the dialog
	get_tree().paused = true
	$DialogPopup.popup()
	$DialogPopup/AnimationPlayer.playback_speed = 60.0 / dialog.length()
	$DialogPopup/AnimationPlayer.play("ShowDialog")

func close():
	# Pause for a short amount of time so that the input is cleared and an
	# interact action is not immediately triggered.
	yield(get_tree().create_timer(0.100), "timeout")
	
	# Hide the dialog and unfreeze the game.
	$DialogPopup.hide()
	get_tree().paused = false
	
func _ready():
	# Disable processing input by default, so this doesn't react to player
	# input until shown.
	set_process_input(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	set_process_input(true)

func _input(event):
	if Input.is_action_just_released("interact"):
		set_process_input(false)
		npc.talk()
