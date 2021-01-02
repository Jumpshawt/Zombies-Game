extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal upgrades_popup

func _ready():
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interacted", self, "handle_interacted")

func handle_interacted(eee):
	if eee == static_body:
		emit_signal("upgrades_popup")
