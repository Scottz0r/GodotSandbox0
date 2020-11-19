extends KinematicBody2D

export(float) var speed = 200

# Movement velocity
var velocity = Vector2()

func get_input():	
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	if Input.is_action_pressed("down"):
		velocity.y += 1
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("right"):
		velocity.x += 1

	velocity = velocity.normalized() * speed

	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func _input(event):
	# if event.is_action_pressed("interact"):
	if Input.is_action_just_released("interact"):
		maybe_interact()
		
		# TODO: Raycast collision?
		# if len($CollisionShape2D.get_overlapping_areas()) > 0:
		# 	var target = $CollisionShape2D.get_overlapping_areas()[0]
		# 	if target.is_in_group("npc"):
		#		target.talk()

func maybe_interact():
	for target in $Area2D.get_overlapping_areas():
		if target.is_in_group("npc"):
			target.talk()
			break
