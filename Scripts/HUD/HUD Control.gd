extends Control

onready var infotransfer = $"/root/InfoTransfer"
onready var money = $Money
onready var round_number = $Round
onready var debuglabel = $Debug

func _process(delta):
	money.set_text("Money: " + str(infotransfer.money))
	round_number.set_text("Round: " + str(infotransfer.round_num))
	debuglabel.set_text(str(infotransfer.zombies_to_spawn[infotransfer.round_num]) + " / " + str(infotransfer.zombies_alive))
