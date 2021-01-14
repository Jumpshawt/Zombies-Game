extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal rifle_shop_popup

func _ready():
	var popup = get_tree().get_root().find_node("Player", true, false)
	popup.connect("interactee", self, "handle_interactee")
	
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interacted", self, "handle_interacted")

func handle_interacted(eee):
	if eee == static_body:
		pass

func handle_interactee(eee):
	if eee == static_body:
		$DisappearTimer.stop()
		$DisappearTimer.start()
		$Control/Label.visible = true

func _on_DisappearTimer_timeout():
	$Control/Label.visible = false
