extends Area

export var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")
export var better_zombie = preload("res://Assets/Enemies/Enemy2.tscn")
var spawnTimeAmplifier = .5

onready var infotransfer = $"/root/InfoTransfer"

var player_in_area = true 
var grace_period_over = false
var activated_areas = 1

var spawn_zombies
var MAXSPAWNTIME = 20
var MINSPAWNTIME = 10
var active = false

func _ready():
	if self.is_in_group("Room1"):
		active = true
	$RoundTimer.start()

func _on_Timer_timeout():
	check_activated()
	var e = better_zombie.instance()
	if infotransfer.zombies_alive > infotransfer.zombies_to_spawn[infotransfer.round_num] * 0.5:
		spawnTimeAmplifier = 0.25
	else:
		spawnTimeAmplifier = 0.5 + (infotransfer.round_num * 0.05) + (0.2 * activated_areas)
	if infotransfer.spawn_zombies == true and active == true and grace_period_over == true:
		if infotransfer.zombies_alive < infotransfer.zombies_to_spawn[infotransfer.round_num]:
			infotransfer.zombies_alive += 1
			add_child(e)
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	$Timer.start()

func _process(delta):
	if infotransfer.changing_rounds == true:
		grace_period_over = false
	check_activated()

func check_activated():
	activated_areas = 0.0
	if self.is_in_group("Room1") and infotransfer.Room1Open == true:
		active = true
		activated_areas += 1
	if self.is_in_group("Room2") and infotransfer.Room2Open == true:
		active = true
		activated_areas += 1
	if self.is_in_group("Room3") and infotransfer.Room3Open == true:
		active = true
		activated_areas += 1
	if self.is_in_group("Room4") and infotransfer.Room4Open == true:
		active = true
		activated_areas += 1
	if self.is_in_group("Room5") and infotransfer.Room5Open == true:
		active = true
		activated_areas += 1
	if self.is_in_group("Room6") and infotransfer.Room6Open == true:
		active = true
		activated_areas += 1

func _on_RoundTimer_timeout():
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	$Timer.start()

func _on_5_Second_Timer_timeout():
	check_activated()
	if grace_period_over == false:
		yield(get_tree().create_timer(3), "timeout")
		grace_period_over = true
