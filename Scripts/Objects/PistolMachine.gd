extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal pistol_shop_popup

func _ready():
	$Control/Label.visible = false
	$Control/Label2.visible = false
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interactee", self, "handle_interacted")
	var popup = get_tree().get_root().find_node("Player", true, false)
	popup.connect("door_popup", self, "handle_interactee")

func handle_interacted(eee):
	print("signal recieved")
	if eee == static_body:
		if infotransfer.money >= 500:
			infotransfer.money -= 500
			infotransfer.pistol_reserve_ammo += 120
		elif infotransfer.money < 500:
			$Control/Label2.visible = true

func handle_interactee(eee):
	if eee == $StaticBody:
		$LabelTimer.stop()
		$LabelTimer.start()
		$Control/Label.visible = true

func _on_LabelTimer_timeout():
	$Control/Label.visible = false
	$Control/Label2.visible = false
