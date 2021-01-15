extends Control

func _ready():
	yield(get_tree().create_timer(7), "timeout")
	#get_tree().change_scene("res://ui/titlescreen.tscn")
