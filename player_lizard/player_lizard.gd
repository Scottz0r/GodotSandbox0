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
	
	# If the character is moving, set the directory of the interact ray.
	if velocity.length() > 0:
		#$InteractionArea.rotation_degrees = rad2deg(velocity.angle())
		$InteractionRay.rotation = velocity.angle()
	
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
	# Try to get a target from either interaction rays.
	#var all_targets = $InteractionArea.get_overlapping_areas()
	#var target = null
	#if len(all_targets):
	#	target = all_targets[0]
	var target = $InteractionRay.get_collider()
	
	if target:
		if target.is_in_group("npc"):
			target.talk()
		elif target.is_in_group("items"):
			target.interact()
		elif target.is_in_group("placeholder"):
			# TODO: Would need to pass "inventory" for now hack in "coin"
			var hack_inventory = "coin" if _has_coin else ""
			target.interact(hack_inventory)


func _injured_timeout():
	input_disabled = false
	$AnimatedSprite.play("idle")


func damage():
	input_disabled = true
	$AnimatedSprite.play("hit")
	$InjuredTimer.start()


func pickup_object(item):
	# TODO: probably should make "item" a string or enumeration.
	if item is Coin:
		_has_coin_set(true)


func remove_item(item):
	if item == "coin":
		_has_coin_set(false)


func _has_coin_set(new_value):
	_has_coin = new_value
	if new_value:
		$CoinPickupSprite.visible = true
		$CoinPickupSprite.play()
	else:
		$CoinPickupSprite.visible = false
		$CoinPickupSprite.stop()
