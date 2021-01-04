extends Area

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"
onready var location_1 = $"../../../HordeSpawnLocations/Spatial"
onready var location_2 = $"../../../HordeSpawnLocations/Spatial2"
onready var location_3 = $"../../../HordeSpawnLocations/Spatial3"
onready var location_4 = $"../../../HordeSpawnLocations/Spatial4"
var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")

#=====ScriptVariables=====#
var zombies_per_horde = 4 #i think this number has one added on also ex 4 -> 5
var zombies_spawned = 0
var hordes_to_spawn = 0
var spawned_hordes = 0
var current_location = "location_1" 
var locationrng = 0

#=====Code=====#

func _ready():
	self.global_transform.origin = location_1.global_transform.origin
	$HordeSpawnTimer.start()

func _process(delta):
	new_round_check()

func change_spawn_location():
	locationrng = rand_range(0, 4)
	if locationrng >= 1 and not current_location == "location_1":
		self.global_transform.origin = location_1.global_transform.origin
		current_location = "location_1"
	elif locationrng >= 2 and not current_location == "location_2":
		self.global_transform.origin = location_2.global_transform.origin
		current_location = "location_2"
	elif locationrng >= 3 and not current_location == "location_3":
		self.global_transform.origin = location_3.global_transform.origin
		current_location = "location_3"
	elif locationrng >= 4 and not current_location == "location_4":
		self.global_transform.origin = location_4.global_transform.origin
		current_location = "location_4"
	print("location changed")

func spawn_horde():
	if spawned_hordes < check_for_hordes(infotransfer.round_num) and infotransfer.spawn_zombies == true:
		zombies_spawned = 0
		var b = basic_zombie.instance()
		while zombies_spawned < zombies_per_horde:
			zombies_spawned += 1
			infotransfer.zombies_alive += 1
			self.add_child(b)
			b.global_transform.origin = self.global_transform.origin
			print("zombie spawned")
		spawned_hordes += 1
		print("horde spawned")
 
func check_for_hordes(val):
	if infotransfer.hordes_to_spawn[val] > 0:
		return infotransfer.hordes_to_spawn[val]
	else:
		return null

func new_round_check():
	if infotransfer.changing_rounds == true:
		spawned_hordes = 0
		hordes_to_spawn = infotransfer.hordes_to_spawn[infotransfer.round_num]
		print("Successfull new round")

func _on_HordeSpawnTimer_timeout():
	if infotransfer.zombies_alive + 4 < infotransfer.zombies_to_spawn[infotransfer.round_num]:
		spawn_horde()
		$HordeSpawnTimer.start()
		change_spawn_location()
		print("works i guess")
