extends Spatial

#=====Script Variables=====#
var plug_walking : bool = false
var dead : bool = false

#=====Signals=====#
signal dead

func _ready():
	walk()

func walk():
	if not plug_walking:
		$AnimationPlayer.play("Walk")
	elif plug_walking:
		pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if plug_walking:
		$AnimationPlayer.play("Walk")
	elif not plug_walking:
		$AnimationPlayer.stop()


func _on_Enemy_walk():
	if not dead:
		walk()

func _on_Enemy_stop_walking():
	pass

func _on_Enemy_dead():
	$AnimationPlayer.stop()
