extends Spatial

onready var infotransfer = $"/root/InfoTransfer"

func _ready():
	if infotransfer.gun_state == "pistol":
		self.scale = Vector3(0.1 + (0.1 * infotransfer.pistol_upgrade_level),0.1 + (0.1 * infotransfer.pistol_upgrade_level),0.1 + (0.1 * infotransfer.pistol_upgrade_level))
	if infotransfer.gun_state == "rifle":
		self.scale = Vector3(0.125 + (0.125 * infotransfer.rifle_upgrade_level), 0.125 + (0.125 * infotransfer.rifle_upgrade_level), 0.125 + (0.125 * infotransfer.rifle_upgrade_level))
	if infotransfer.gun_state == "shotgun":
		self.scale = Vector3(0.15 + (0.15 * infotransfer.shotgun_upgrade_level), 0.15 + (0.15 * infotransfer.shotgun_upgrade_level), 0.15)
	var get_collider = get_tree().get_root().find_node("Player", true, false)
	get_collider.connect("bullet_hole_collider", self, "find_collider")

func find_collider(eee):
	if eee == get_parent() and get_parent().is_in_group("Enemy"):
		queue_free()

func _on_Timer_timeout():
	queue_free()
