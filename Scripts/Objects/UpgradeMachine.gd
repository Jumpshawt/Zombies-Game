extends Spatial

onready var static_body = $StaticBody
onready var infotransfer = $"/root/InfoTransfer"

signal upgrades_popup

func _ready():
	$Control/Label.visible = false
	$Control/Label2.visible = false
	var hand_interact = get_tree().get_root().find_node("Player", true, false)
	hand_interact.connect("interactee", self, "handle_interacted")
	var popup = get_tree().get_root().find_node("Player", true, false)
	popup.connect("door_popup", self, "handle_interactee")

func handle_interacted(eee):
	if eee == static_body:
		if infotransfer.gun_state == "pistol":
			if infotransfer.money >= infotransfer.pistol_upgrade_cost:
				infotransfer.money -= infotransfer.pistol_upgrade_cost
				infotransfer.pistol_upgrade_level += 1
			elif infotransfer.money < infotransfer.pistol_upgrade_cost:
				$Control/Label2.visible = true
		if infotransfer.gun_state == "rifle":
			if infotransfer.money >= infotransfer.rifle_upgrade_cost:
				infotransfer.money -= infotransfer.rifle_upgrade_cost
				infotransfer.rifle_upgrade_level += 1
			elif infotransfer.money < infotransfer.rifle_upgrade_cost:
				$Control/Label2.visible = true
		if infotransfer.gun_state == "shotgun":
			if infotransfer.money >= infotransfer.shotgun_upgrade_cost:
				infotransfer.money -= infotransfer.shotgun_upgrade_cost
				infotransfer.shotgun_upgrade_level += 1
			elif infotransfer.money < infotransfer.shotgun_upgrade_cost:
				$Control/Label2.visible = true

func update_label():
	if infotransfer.gun_state == "pistol":
		$Control/Label.set_text("E to Buy Pistol Upgrade \n Cost = " + str(infotransfer.pistol_upgrade_cost))
	elif infotransfer.gun_state == "rifle":
		$Control/Label.set_text("E to Buy Rifle Upgrade \n Cost = " + str(infotransfer.rifle_upgrade_cost))
	elif infotransfer.gun_state == "shotgun":
		$Control/Label.set_text("E to Buy Shotgun Upgrade \n Cost = " + str(infotransfer.shotgun_upgrade_cost))

func handle_interactee(eee):
	if eee == static_body:
		update_label()
		$Timer.stop()
		$Timer.start()
		$Control/Label.visible = true

func _on_Timer_timeout():
	$Control/Label.visible = false
	$Control/Label2.visible = false
