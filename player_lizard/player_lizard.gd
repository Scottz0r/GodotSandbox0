extends KinematicBody2D

export(float) var speed = 50


var velocity = Vector2()  # Movement velocity
var input_disabled = false  # If user input is disabled.
var _has_coin = false


func _ready():
	$InjuredTimer.connect("timeout", self, "_injured_timeout")


func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _process(delta):
	_process_input()


func _process_input():	
	# Process input. Not done in _input method because _input is weird and
	# doesn't work with animations and pausing input and such.
	
	# Always reset velocity back to default to stop moving.
	velocity = Vector2()
	
	# If input is disabled for this character, do nothing.
	if input_disabled:
		return
	
	# Handle movement.
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	if Input.is_action_pressed("down"):
		velocity.y += 1
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("right"):
		velocity.x += 1

	velocity = velocity.normalized() * speed
	_set_animation()
	
	if Input.is_action_just_released("interact"):
		_maybe_interact()


func _set_animation():
		# Flip the sprite depending on direction.
	if velocity.x < 0 and $AnimatedSprite.flip_h == false:
		$AnimatedSprite.flip_h = true
	elif velocity.x > 0 and $AnimatedSprite.flip_h == true:
		$AnimatedSprite.flip_h = false
	
	# Change the animation based on movement. Default back to idle.
	# TODO: How to handle getting hit.
	if velocity.x != 0 or velocity.y != 0:
		if $AnimatedSprite.animation != "run":
			$AnimatedSprite.play("run")
	elif $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")


func _maybe_interact():
	# TODO: Maybe raycast in direction of movement?
	for target in $InteractionArea.get_overlapping_areas():
		if target.is_in_group("npc"):
			target.talk()
			break
		elif target.is_in_group("items"):
			target.interact()


func _injured_timeout():
	input_disabled = false
	$AnimatedSprite.play("idle")


func damage():
	input_disabled = true
	$AnimatedSprite.play("hit")
	$InjuredTimer.start()


func pickup_object(item):
	if item is Coin:
		_has_coin_set(true)


func _has_coin_set(new_value):
	_has_coin = new_value
	if new_value:
		$CoinPickupSprite.visible = true
		$CoinPickupSprite.play()
	else:
		$CoinPickupSprite.visible = false
		$CoinPickupSprite.stop()
