extends CanvasLayer

# Notify that the dialog process is complete.
signal complete

# Internal signal to notify when the interaction button pressed.
signal _interact_pressed


func _ready():
	connect("_interact_pressed", self, "_on_interact_pressed")
	
	# Reset display items to default. These are set in editor for development.
	$DialogPopup/BlackRect/DialogLabel.percent_visible = 0.0
	$DialogPopup/BlackRect/TextureRect.texture = null


func play(dialog: Array):
	get_tree().paused = true
	$DialogPopup.popup()
	
	# Json like {"Key
	for d in dialog:
		_show_text(d["text"], d["$sprite"])
		# Wait a little bit before waiting for the interaction keypress. This
		# will prevent the dialog from going to next or ending too soon.
		yield(get_tree().create_timer(0.100), "timeout")
		yield(self, "_interact_pressed")
	
	$DialogPopup.hide()
	get_tree().paused = false
	emit_signal("complete")


func _process(delta):
	if Input.is_action_just_released("interact"):
		emit_signal("_interact_pressed")


func _show_text(text, sprite):
	# TODO: Maybe show a name (but not putting name makes community name,
	# which is better)
	
	# Show a sprite, if given.
	if sprite != null:
		$DialogPopup/BlackRect/TextureRect.texture = sprite
	else:
		$DialogPopup/BlackRect/TextureRect.texture = null
	
	# Always reset percent visible to prevent flashing when switching text.
	$DialogPopup/BlackRect/DialogLabel.percent_visible = 0.0
	$DialogPopup/BlackRect/DialogLabel.text = text
	$DialogPopup/AnimationPlayer.playback_speed = 60.0 / text.length()
	$DialogPopup/AnimationPlayer.play("ShowDialog")


# TODO: Could use this to know if interaction will speed up dialog or go to next.
func _on_AnimationPlayer_animation_finished(animation_name):
	pass
