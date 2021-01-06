extends Spatial

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"

#=====ScriptVariables=====#
var barrier_health = 100
var max_health = 100
var barrier_alive : bool = true
var zombies_in_area: int = 0
var player_in_area: bool = false

#=====Signals=====#
signal zombie_pause(object)
signal zombie_unpause

func _ready():
	pass

func _process(delta):
	check_health()
	update_health(delta)

func _on_RepairArea_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		print("player entered area")

func _on_RepairArea_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		print("player left area")


func _on_ZombieArea_body_entered(body):
	if body.is_in_group("Enemy"):
		zombies_in_area += 1
		print("a zombie entered area")
	if barrier_alive == true:
		emit_signal("zombie_pause", body)

func _on_ZombieArea_body_exited(body):
	if body.is_in_group("Enemy"):
		zombies_in_area -= 1
		print("a zombie left the area")

func update_health(eee):
	if zombies_in_area > 0:
		barrier_health -= (5 * zombies_in_area) * eee
	if player_in_area == true and Input.is_action_pressed("interact"):
		barrier_health += 20 * eee

func check_health():
	if barrier_health > (max_health * .75):
		$AnimationPlayer.play("BarrierHealth.3") 
		barrier_alive = true
	elif barrier_health > (max_health * .5):
		$AnimationPlayer.play("BarrierHealth.2")
		barrier_alive = true
	elif barrier_health > (max_health * .25):
		$AnimationPlayer.play("BarrierHealth.1")
		barrier_alive = true
	elif barrier_health < 0:
		$AnimationPlayer.play("BarrierHealth.0")
		barrier_alive = false
