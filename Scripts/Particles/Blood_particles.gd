extends Spatial

#=====Randomness=====#
export var ss_min = 0.5  #Scale Size - min
export var ss_max = 1.5  #Scale Size - max

func _ready():
	
	self.set_scale(Vector3(rand_range(ss_min, ss_max),rand_range(ss_min, ss_max),rand_range(ss_min, ss_max)))
	$Particles.emitting = true
	$Particles2.emitting = true
	
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
