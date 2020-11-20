extends Node2D


export(int) var speed = 50
signal path_done


var _path: PathFollow2D = null
var _follow_path: bool = false
var _move_dir: Vector2


func _physics_process(delta):
	
	if _follow_path and _path:
		var prior_pos = _path.get_global_position()
		_path.set_offset(_path.get_offset() + (speed * delta))
		position = _path.get_global_position()
		
		_move_dir = prior_pos.direction_to(position)
		
		# Once the end of the path has been reached, stop following it an signal.
		if _path.unit_offset == 1.0:
			_follow_path = false
			emit_signal("path_done")
	else:
		pass


func _process(delta):
	_animate_sprite()
	

func _animate_sprite():
	if _follow_path:
		# Start run animation if not already running.
		if $AnimatedSprite.animation != "run":
			$AnimatedSprite.play("run")
		
		# Maybe flip sprite based off of movement direction.
		if _move_dir.x < 0 and $AnimatedSprite.flip_h == false:
			$AnimatedSprite.flip_h = true
		elif _move_dir.x > 0 and $AnimatedSprite.flip_h == true:
			$AnimatedSprite.flip_h = false
		
	elif $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")


func set_path(path: PathFollow2D):
	_path = path


func play_path():
	if _path:
		# Immediately set Steve's position to the path's position to avoid flickering.
		position = _path.get_global_position()
		_follow_path = true
