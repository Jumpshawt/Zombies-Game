extends Spatial

onready var door_object = $"Armature/Plane039/StaticBody"

func _ready():
	print(door_object)
	$AnimationPlayer.play("door1_close")
	var player_open_door = get_tree().get_root().find_node("Player", true, false)
	player_open_door.connect("door_open", self, "handle_door_open")

func handle_door_open(object):
	print(object)
	if object == door_object:
		$AnimationPlayer.play("door1_open")
