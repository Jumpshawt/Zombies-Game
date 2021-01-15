extends Spatial

var randomchance : float
var playchance = 0.25

func _process(_delta):
	randomchance = rand_range(0, 100)
	if playchance >= randomchance:
		$AudioStreamPlayer3D.play()
