extends Spatial

onready var static_body = $StaticBody
#onready var infotransfer = $"/root/InfoTransfer"
#Why does it load infotransfer and never use it? also you forgot to capitlize the T

signal shotgun_shop_popup

func _ready():
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interacted", self, "handle_interacted")

func handle_interacted(eee):
	if eee == static_body:
		emit_signal("shotgun_shop_popup")
