extends Spatial

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"

#=====ScriptVariables=====#

#3 = finished
#2 = repairing 
#1 = destroying 
var repaired = 3
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

func _on_RepairArea_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_RepairArea_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false


func _on_ZombieArea_body_entered(body):
	if body.is_in_group("Enemy"):
		zombies_in_area += 1
	if barrier_alive == true:
		emit_signal("zombie_pause", body)

func _on_ZombieArea_body_exited(body):
	if body.is_in_group("Enemy"):
		zombies_in_area -= 1

func update_health(delta2):
	if zombies_in_area > 0:
		barrier_health -= (10 * zombies_in_area) * delta2
	if player_in_area == true and Input.is_action_pressed("interact"):
		barrier_health += 20 * delta2

func labelpopup():
	if player_in_area and barrier_health <= 50:
		$Control/Label.visible = true
	else:
		$Control/Label.visible = false

func check_health():	
	if barrier_health < (max_health * .75) and state == 3:
		$AnimationPlayer.play("Wood_break1") 
		print("playing woodBreak3")
		barrier_alive = true
		state = 2 
	if barrier_health < (max_health * .5) and state == 2:
		$AnimationPlayer.play("Wood_break2")
		print("playing woodBreak2")
		barrier_alive = true
		state = 1
	if barrier_health < (max_health * .25) and state == 1:
		$AnimationPlayer.play("Wood_break3")
		barrier_alive = true
		print("playing woodBreak1")
		state = 0
#	elif barrier_health < 0:
#		$AnimationPlayer.play("BarrierHealth.0")
#		barrier_alive = false
#		print("playing woodBreak0")
#
