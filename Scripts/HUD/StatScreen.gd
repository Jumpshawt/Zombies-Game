extends Control

onready var infotransfer = $"/root/InfoTransfer"

var total_time_taken : int = 0 
var rank = "lol it didnt work"

func _ready():
	total_time_taken = (infotransfer.total_mins_taken * 60) + (infotransfer.total_hours_taken * 3600) + infotransfer.total_seconds_taken
	print(total_time_taken)
	find_rank()
	update_stats()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func update_stats():
	$Label.set_text("Total Zombies Killed = " + str(infotransfer.total_zombies_killed))
	$Label2.set_text("Total Damage Dealt = "+ str(round(infotransfer.total_damage_dealt)))
	$Label3.set_text("Total Rounds Survived = " + str(infotransfer.rounds_survived))
	$Label4.set_text("Total Money Earned = "+ str(round(infotransfer.total_money_earned)))
	$Label5.set_text("Total Damage Taken = "+ str(round(infotransfer.total_damage_taken)))
	$Label6.set_text("Total Time = "+ str(infotransfer.total_hours_taken) + "h " + str(infotransfer.total_mins_taken) + "m " + str(round(infotransfer.total_seconds_taken)) + "s")
	$Label7.set_text("Rank = "+ rank)

func find_rank():
	if total_time_taken <= 120:
		rank = "D-"
	elif total_time_taken <= 160 and infotransfer.total_damage_dealt > 400:
		rank = "D"
	elif total_time_taken <= 200 and infotransfer.total_damage_dealt > 800:
		rank = "D+"
	elif total_time_taken <= 240 and infotransfer.total_damage_dealt > 1200:
		rank = "C-"
	elif total_time_taken <= 280 and infotransfer.total_damage_dealt > 1600:
		rank = "C"
	elif total_time_taken <= 320 and infotransfer.total_damage_dealt > 2000:
		rank = "C+"
	elif total_time_taken <= 360 and infotransfer.total_damage_dealt > 3000:
		rank = "B-"
	elif total_time_taken <= 400 and infotransfer.total_damage_dealt > 4000:
		rank = "B"
	elif total_time_taken <= 440 and infotransfer.total_damage_dealt > 5000:
		rank = "B+"
	elif total_time_taken <= 480 and infotransfer.total_damage_dealt > 6000:
		rank = "A-"
	elif total_time_taken <= 520 and infotransfer.total_damage_dealt > 7000:
		rank = "A"
	elif total_time_taken <= 560 and infotransfer.total_damage_dealt > 8000:
		rank = "A+"
	elif total_time_taken <= 600 and infotransfer.total_damage_dealt > 10000:
		rank = "S-"
	elif total_time_taken <= 800 and infotransfer.total_damage_dealt > 20000:
		rank = "S"
	elif total_time_taken <= 1000 and infotransfer.total_damage_dealt > 30000:
		rank = "S+"
	elif total_time_taken <= 1500 and infotransfer.total_damage_dealt > 100000:
		rank = "POG"

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
	infotransfer.round_num = 1
	infotransfer.rifle_ammo_loaded = 30
	infotransfer.rifle_reserve_ammo = 90
	infotransfer.shotgun_activated = false
	infotransfer.rifle_activated = false
	get_tree().change_scene("res://Main Scene.tscn")
