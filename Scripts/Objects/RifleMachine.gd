extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal rifle_shop_popup

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
		if not infotransfer.rifle_activated:
			if infotransfer.money >= 1500:
				infotransfer.money -= 1500
				infotransfer.rifle_activated = true
				infotransfer.gun_changing = true
				infotransfer.gun_state = "rifle"
				$Control/Label.set_text("E to Buy Rifle Ammo \nCost = 500 ")
			elif infotransfer.money <= 1500:
				$Control/Label2.visible = true
		elif infotransfer.rifle_activated == true:
			if infotransfer.money >= 500:
				infotransfer.money -= 500
				infotransfer.rifle_reserve_ammo += 120
			elif infotransfer.money < 500:
				$Control/Label2.visible = true

func handle_interactee(eee):
	if eee == static_body:
		$DisappearTimer.stop()
		$DisappearTimer.start()
		$Control/Label.visible = true

func _on_DisappearTimer_timeout():
	$Control/Label.visible = false
	$Control/Label2.visible = false
