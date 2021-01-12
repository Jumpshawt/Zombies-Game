extends Spatial

#=====Door Stuff=====#
var unlocked : bool = false
var open : bool = false
var things_in_area : int = 0

func _ready():
	$AnimationPlayer.play("Start")
	var check_for_interacts = get_tree().get_root().find_node("Player", true, false)
	check_for_interacts.connect("interactee", self, "handle_interacted")

func handle_interacted(object):
	if object == $StaticBody and not unlocked:
		$AnimationPlayer.play("door1_open")
		unlocked = true

func _process(_delta):
	open_and_close()

func open_and_close():
	if things_in_area > 0 and unlocked and not open:
		$CloseTimer.stop()
		$AnimationPlayer.play("door1_open")
		open = true
	if things_in_area == 0 and unlocked and open:
		$CloseTimer.start()
		open = false

func _on_InteractArea_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		things_in_area += 1

func _on_InteractArea_body_exited(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		things_in_area -= 1

func _on_CloseTimer_timeout():
	$AnimationPlayer.play("door1_open", -1, -1, true)
	open = false
