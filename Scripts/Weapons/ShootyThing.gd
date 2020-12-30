extends MeshInstance

func _ready():
	$AnimationPlayer.play("Fade Out")
	self.connect(

func _on_ShootyPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		die()
