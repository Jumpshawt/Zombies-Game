extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal shotgun_shop_popup

func _ready():
	$Control/Label.visible = false
	$Control/Label2.visible = false
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interactee", self, "handle_interacted")
	var popup = get_tree().get_root().find_node("Player", true, false)
	popup.connect("door_popup", self, "handle_interactee")

func handle_interacted(eee):
	if eee == $StaticBody:
		if not infotransfer.shotgun_activated:
			if infotransfer.money >= 2000:
				infotransfer.money -= 2000
				infotransfer.shotgun_activated = true
				infotransfer.gun_changing = true
				infotransfer.gun_state = "shotgun"
				$ILikeThisWeapon.play()
				$Control/Label.set_text("E to Buy Shotgun Ammo \nCost = 750 ")
			elif infotransfer.money <= 2000:
				$Control/Label2.visible = true
		elif infotransfer.shotgun_activated == true:
			if infotransfer.money >= 750:
				infotransfer.money -= 750
				emit_signal("shotgun_ammo_bought")
			elif infotransfer.money < 750:
				$Control/Label2.visible = true

func handle_interactee(eee):
	if eee == static_body:
		$GoAwayTimer.stop()
		$GoAwayTimer.start()
		$Control/Label.visible = true

func _on_GoAwayTimer_timeout():
	$Control/Label.visible = false
	$Control/Label2.visible = false
