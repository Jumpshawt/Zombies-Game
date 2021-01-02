extends Area

export var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")
var spawnTimeAmplifier = .5

onready var infotransfer = $"/root/InfoTransfer"

#var r_num = infotransfer.round_num

var max_zombies = 5

#var round_num = infotransfer.round_num


var spawn_zombies
export var MAXSPAWNTIME = 30
export var MINSPAWNTIME = 15
export var active = true

func _ready():
	$Timer.start()

func _on_Timer_timeout():
	var e = basic_zombie.instance()
	
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	if infotransfer.spawn_zombies == true && active == true:
		if infotransfer.zombies_alive < infotransfer.zombies_to_spawn[infotransfer.round_num]:
			infotransfer.zombies_alive += 1
			add_child(e)
	$Timer.start()
