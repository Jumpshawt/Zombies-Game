extends Control

func _process(delta):
	if Input. is_action_pressed("escape"):
		get_tree().change_scene("res://ui/titlescreen.tscn")
