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

func _process(delta):
	#if spawnTimeAmplifier >= MINSPAWNAMPLIFIER:
		#spawnTimeAmplifier -= 0.01 * delta
		#max_zombies += 0.2 * delta 
	pass

func _on_Timer_timeout():
	var e = basic_zombie.instance()
	
	#e.global_transform.origin = get_parent().global_transform.origin# + Vector3(0, 1, 0) 
	#This is a useless line that literally accomplishes nothing, it just takes the Root of the level (0,0,0) and sets itself to that, which it was already at  
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	if infotransfer.spawn_zombies == true && active == true:
		if infotransfer.zombies_alive < infotransfer.zombies_to_spawn[infotransfer.round_num]:
			infotransfer.zombies_alive += 1
			add_child(e)
	$Timer.start()
	
