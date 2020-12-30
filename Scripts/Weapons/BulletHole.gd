extends Spatial

func _ready():
	var get_collider = get_tree().get_root().find_node("Player", true, false)
	get_collider.connect("bullet_hole_collider", self, "find_collider")

func find_collider(eee):
	if eee == get_parent() and get_parent().is_in_group("Enemy"):
		queue_free()

func _on_Timer_timeout():
	queue_free()
