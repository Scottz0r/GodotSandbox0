extends Node2D


func _ready():
	$DialogAction.load_file()
	$FancyDialog.connect("complete", self, "_dialog_complete")
	


func _process(delta):
	if Input.is_action_just_released("interact"):
		$FancyDialog.play($DialogAction.get_data())


func _dialog_complete():
	print("Dialog has completed!")
