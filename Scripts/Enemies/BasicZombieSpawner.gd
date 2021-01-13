extends Area

export var basic_zombie = preload("res://Assets/Enemies/Enemy1.tscn")
export var better_zombie = preload("res://Assets/Enemies/Enemy2.tscn")
var spawnTimeAmplifier = .5

onready var infotransfer = $"/root/InfoTransfer"

var player_in_area = false 
var grace_period_over = false
var activated_areas = 1

var spawn_zombies
export var MAXSPAWNTIME = 30
export var MINSPAWNTIME = 15
export var active = true

func _ready():
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	$Timer.start()
	if not grace_period_over:
		$RoundTimer.start()

func _on_Timer_timeout():
	var e = better_zombie.instance()
	if infotransfer.zombies_alive > infotransfer.zombies_to_spawn[infotransfer.round_num] * 0.5:
		spawnTimeAmplifier = 0.25
	else:
		spawnTimeAmplifier = 1 + (infotransfer.round_num * 0.05) + (0.1 * activated_areas)
	$Timer.set_wait_time(rand_range(MINSPAWNTIME, MAXSPAWNTIME)* spawnTimeAmplifier)
	if infotransfer.spawn_zombies == true and active == true and player_in_area == true and grace_period_over:
		if infotransfer.zombies_alive < infotransfer.zombies_to_spawn[infotransfer.round_num]:
			infotransfer.zombies_alive += 1
			add_child(e)
	$Timer.start()

func check_activated():
	activated_areas = 0.001
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

func _on_DetectArea_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_DetectArea_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false


func _on_RoundTimer_timeout():
	grace_period_over = true


func _on_5_Second_Timer_timeout():
	check_activated()
