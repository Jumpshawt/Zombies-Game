extends Area

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"
var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")

export var active = true

#=====ScriptVariables=====#
var zombies_per_horde = 6 
var zombies_spawned = 0 #amount of zombies spawned, used in making only 6 spawn
var hordes_to_spawn = 0 #amount of hordes to spawn, updates every new round. For total list see infotransfer.gd
var spawned_hordes = 0 
var min_wait_time = 15 
var max_wait_time = 45

#=====Code=====#

func _ready():
	$HordeSpawnTimer.set_wait_time(rand_range(15,45))
	$HordeSpawnTimer.start()

func _process(_delta):
	new_round_check()

func spawn_horde():
	if spawned_hordes < hordes_to_spawn and infotransfer.spawn_zombies == true:
		zombies_spawned = 0
		$IndividualZombieTimer.start()

func new_round_check():
	hordes_to_spawn = infotransfer.hordes_to_spawn[infotransfer.round_num]
	if infotransfer.changing_rounds == true:
		spawned_hordes = 0

func _on_HordeSpawnTimer_timeout():
	if infotransfer.zombies_alive + zombies_per_horde < infotransfer.zombies_to_spawn[infotransfer.round_num]:
		spawn_horde()
		$HordeSpawnTimer.set_wait_time(rand_range(15,45))
		$HordeSpawnTimer.start()

func _on_IndividualZombieTimer_timeout():
	if active:
		var b = basic_zombie.instance()
		self.add_child(b)
		b.global_transform.origin = self.global_transform.origin
		zombies_spawned += 1
		infotransfer.zombies_alive += 1
		if zombies_spawned < zombies_per_horde:
			$IndividualZombieTimer.start()
		else:
			spawned_hordes += 1
