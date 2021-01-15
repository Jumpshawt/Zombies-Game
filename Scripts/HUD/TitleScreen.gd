extends Control

func _ready():
	pass 

func _on_Button2_pressed():
	get_tree().quit()

func _on_Button_pressed():
	get_tree().change_scene("res://Main Scene.tscn")

func _on_Button3_pressed():
	get_tree().change_scene("res://ui/creditscreen.tscn")

func _on_Button5_pressed():
	get_tree().change_scene("res://ui/controlscreen.tscn")


func _on_Button6_pressed():
	get_tree().change_scene("res://ui/Video.tscn")
