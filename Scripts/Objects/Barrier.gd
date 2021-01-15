extends Spatial

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"

#=====ScriptVariables=====#

#3 = finished
#2 = repairing 
#1 = destroying 
var is_repairing = false
var state = 3
var barrier_health = 100
var max_health = 100
var barrier_alive : bool = true
var zombies_in_area: int = 0
var player_in_area: bool = false

#=====Signals=====#
signal zombie_pause(object)
signal zombie_unpause

func _ready():
	$AnimationPlayer.play("Wood_repair1")
	pass

func _process(delta):
	check_health()
	update_health(delta)
	labelpopup()
	if player_in_area and Input.is_action_just_pressed("interact"):
		$HammeringSound.play()
	elif player_in_area == false or Input.is_action_just_released("interact") or barrier_health == 100:
		$HammeringSound.stop()

func _on_RepairArea_body_entered(body):
	#If the player enters this turns on
	if body.is_in_group("Player"):
		player_in_area = true

func _on_RepairArea_body_exited(body):
	#If the player exits this turns on
	if body.is_in_group("Player"):
		player_in_area = false


func _on_ZombieArea_body_entered(body):
	#If the zombie enters this turns on
	if body.is_in_group("Enemy"):
		zombies_in_area += 1
	if barrier_alive == true:
		emit_signal("zombie_pause", body)

func _on_ZombieArea_body_exited(body):
	#If the zombie exits this turns on
	if body.is_in_group("Enemy"):
		zombies_in_area -= 1

func update_health(delta2):
	#Check if zombies are near the barrier if they are reduce the health of barrier, 
	if zombies_in_area > 0:
		barrier_health -= (5 * zombies_in_area) * delta2
	#Player repairing barrier 
	if player_in_area == true and Input.is_action_pressed("interact"):
		is_repairing = true
		barrier_health += 20 * delta2
	if player_in_area == true and Input.is_action_just_released("interact"):
		is_repairing = false

func labelpopup():
	if player_in_area and barrier_health <= 50:
		$Control/Label.visible = true
	else:
		$Control/Label.visible = false

func slam():
	$Slam.set_pitch_scale(rand_range(.75, 1.25))
	$Slam.set_unit_db(rand_range(0, 20))
	$Slam.play()

func play_break():
	$AudioStreamPlayer3D.set_pitch_scale(rand_range(.75, 1.25))
	$AudioStreamPlayer3D.set_unit_db(rand_range(0, 20))
	$AudioStreamPlayer3D.play()

func check_health():	
	#If the player isn't repairing excecute line, otherwise go to else function
	if is_repairing == false:
		
		if barrier_health < (max_health * .75) and state == 3:
			$AnimationPlayer.play("Wood_break1") 
			print("playing woodBreak3")
			play_break()
			barrier_alive = true
			state = 2
		if barrier_health < (max_health * .5) and state == 2:
			$AnimationPlayer.play("Wood_break2")
			print("playing woodBreak2")
			play_break()
			barrier_alive = true
			state = 1
		if barrier_health < (max_health * .25) and state == 1:
			$AnimationPlayer.play("Wood_break3")
			play_break()
			barrier_alive = true
			print("playing woodBreak1")
			state = 0
	#If player repairing true, excecute 
	else:
		if barrier_health > (max_health * .75) and state == 2:
			$AnimationPlayer.play("Wood_repair1")
			slam()
			print("playing woodrepair3")
			infotransfer.money += 10
			barrier_alive = true
			state = 3 
		if barrier_health > (max_health * .5) and state == 1:
			$AnimationPlayer.play("Wood_repair2")
			slam()
			print("playing woodrepair2")
			infotransfer.money += 10
			barrier_alive = true
			state = 2
		if barrier_health > (max_health * .25) and state == 0:
			$AnimationPlayer.play("Wood_repair3")
			slam()
			barrier_alive = true
			infotransfer.money += 10
			print("playing woodrepair1")
			state = 1
#	elif barrier_health < 0:
#		$AnimationPlayer.play("BarrierHealth.0")
#		barrier_alive = false
#		print("playing woodBreak0")
