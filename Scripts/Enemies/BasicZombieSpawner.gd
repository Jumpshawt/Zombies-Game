extends Area

export var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")
export var better_zombie = preload("res://Assets/Enemies/Enemy2.tscn")
var spawnTimeAmplifier = .5

onready var infotransfer = $"/root/InfoTransfer"

var max_zombies = 5

var spawn_zombies
export var MAXSPAWNTIME = 30
export var MINSPAWNTIME = 15
export var active = true

func _ready():
	$Timer.start()

func _process(delta):
	if Input.is_action_just_pressed("interact") and active == true:
		var e = better_zombie.instance()
		self.add_child(e)

func _on_Timer_timeout():
	var e = better_zombie.instance()
	if infotransfer.zombies_alive > infotransfer.zombies_to_spawn[infotransfer.round_num] * 0.5:
		spawnTimeAmplifier = 0.25
	else:
		spawnTimeAmplifier = 1 + (infotransfer.round_num * 0.05)
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	if infotransfer.spawn_zombies == true && active == true:
		if infotransfer.zombies_alive < infotransfer.zombies_to_spawn[infotransfer.round_num]:
			infotransfer.zombies_alive += 1
			add_child(e)
	$Timer.start()
	
