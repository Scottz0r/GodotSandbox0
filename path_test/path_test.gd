extends Node2D


var _is_steve_playing = false


func _ready():
	$NpcSteve.visible = false
	
	# For demo, set placeholder to fulfilled from the start
	$Coin1Placeholder.fulfill()


func _process(delta):
	if Input.is_action_just_released("interact"):
		if not _is_steve_playing:
			_play_steve()


func _play_steve():
	_is_steve_playing = true
	
	# Walk through Path1
	$Path1/PathFollow1.unit_offset = 0.0
	$NpcSteve.set_path($Path1/PathFollow1)
	$NpcSteve.play_path()
	
	# Set visible after path starting to avoid a flash of the sprite where ever
	# it was temporiarly placed.
	$NpcSteve.visible = true 
	
	# Wait for first path to finish, then do stuff.
	yield($NpcSteve, "path_done")

	# Pickup coin
	yield(get_tree().create_timer(0.25), "timeout")
	$Coin1Placeholder.visible = false
	yield(get_tree().create_timer(0.25), "timeout")
	
	# Go through Path2
	$Path2/PathFollow2.unit_offset = 0.0
	$NpcSteve.set_path($Path2/PathFollow2)
	$NpcSteve.play_path()
	yield($NpcSteve, "path_done")
