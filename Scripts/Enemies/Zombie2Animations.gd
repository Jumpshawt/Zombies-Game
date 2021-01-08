extends Spatial

var move_state = null

func _ready():
	pass


func _on_Enemy_runner():
	move_state = "runner"
	$AnimationPlayer.play("Run")

func _on_Enemy_walker():
	move_state = "walk"
	$AnimationPlayer.play("Walk")


func _on_AnimationPlayer_animation_finished(anim_name):
	if move_state == "walk": 
		if anim_name == "Walk":
			$AnimationPlayer.play("Walk")
		if anim_name == "Attack1":
			$AnimationPlayer.play("Walk")
		if anim_name == "Attack2":
			$AnimationPlayer.play("Walk")
		if anim_name == "Kick":
			$AnimationPlayer.play("Walk")
	
	if move_state == "runner":
		if anim_name == "Run":
			$AnimationPlayer.play("Run")
		if anim_name == "Attack1":
			$AnimationPlayer.play("Run")
		if anim_name == "Attack2":
			$AnimationPlayer.play("Run")
		if anim_name == "Kick":
			$AnimationPlayer.play("Run")


func _on_Enemy_attack1():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Attack1")

func _on_Enemy_attack2():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Attack2")

func _on_Enemy_kick():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Kick")
