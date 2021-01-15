extends Spatial

var move_state = null

func _on_Enemy_runner():
	move_state = "runner"
	$AnimationPlayer.play("Run")

func _on_Enemy_walker():
	move_state = "walk"
	$AnimationPlayer.play("Walk")

#func _process(delta):
#	print($AnimationPlayer.current_animation)
#	if $AnimationPlayer.current_animation == "" and move_state == "walk":
#		$AnimationPlayer.play("Walk")
#	if $AnimationPlayer.current_animation == "" and move_state == "runner":
#		$AnimationPlayer.play("Run")

func _on_AnimationPlayer_animation_finished(anim_name):
	if move_state == "walk": 
		if anim_name == "Walk": 
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Walk")
		if anim_name == "Attack1":
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Walk")
		if anim_name == "Attack2":
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Walk")
		if anim_name == "Kick":
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Walk")
	
	if move_state == "runner":
		if anim_name == "Run":
			$AnimationPlayer.play("Run")
			$AnimationPlayer.playback_speed = 1 
		if anim_name == "Attack1":
			$AnimationPlayer.play("Run")
			$AnimationPlayer.playback_speed = 1 
		if anim_name == "Attack2":
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Run")
		if anim_name == "Kick":
			$AnimationPlayer.playback_speed = 1 
			$AnimationPlayer.play("Run")

	if anim_name == "DeathBack" or anim_name == "DeathForwards":
		yield(get_tree().create_timer(1), "timeout")
		self.queue_free()

func _on_Enemy_attack1():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.playback_speed = 2 
	$AnimationPlayer.play("Attack1")

func _on_Enemy_attack2():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.playback_speed = 2 
	$AnimationPlayer.play("Attack2")

func _on_Enemy_kick():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.playback_speed = 2 
	$AnimationPlayer.play("Kick")

func _on_Enemy_backwards_death():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.playback_speed = 1 
	$AnimationPlayer.play("DeathBack")

func _on_Enemy_forwards_death():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.playback_speed = 1
	$AnimationPlayer.play("DeathForwards")
