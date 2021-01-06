extends Control

onready var infotransfer = $"/root/InfoTransfer"

func _ready():
	update_stats()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func update_stats():
	$Label.set_text("Total Zombies Killed = " + str(infotransfer.total_zombies_killed))
	$Label2.set_text("Total Damage Dealt = "+ str(round(infotransfer.total_damage_dealt)))
	$Label3.set_text("Total Rounds Survived = " + str(infotransfer.rounds_survived))
	$Label4.set_text("Total Money Earned = "+ str(round(infotransfer.total_money_earned)))
	$Label5.set_text("Total Damage Taken = "+ str(round(infotransfer.total_damage_taken)))
	$Label6.set_text("Total Time = "+ str(infotransfer.total_hours_taken) + "h " + str(infotransfer.total_mins_taken) + "m " + str(round(infotransfer.total_seconds_taken)) + "s")


func _on_Button_pressed():
	infotransfer.total_damage_dealt = 0
	infotransfer.total_zombies_killed = 0
	infotransfer.rounds_survived = 0
	infotransfer.total_money_earned = 0
	infotransfer.total_damage_taken = 0
	infotransfer.total_hours_taken = 0
	infotransfer.total_mins_taken = 0
	infotransfer.total_seconds_taken = 0
	infotransfer.money = 0
	get_tree().change_scene("res://Main Scene.tscn")

