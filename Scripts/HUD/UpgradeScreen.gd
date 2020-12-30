extends CanvasLayer

onready var infotransfer = $"/root/InfoTransfer"
onready var pistol_upgrade = $Popup/UpgradePistol
onready var rifle_upgrade = $Popup/UpgradeRifle
onready var shotgun_upgrade = $Popup/UpgradeShotgun
onready var quit = $Popup/Quit

onready var popup = $Popup

var game_paused = false

func _ready():
	var popup_time = get_tree().get_root().find_node("UpgradeMachine", true, false)
	popup_time.connect("upgrades_popup", self, "handle_upgrades")
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	set_upgrade_costs()
	if game_paused and Input.is_action_just_pressed("escape"):
		unpause_game()

func handle_upgrades():
#	popup.visible
	pause_game()

func set_upgrade_costs():
	pistol_upgrade.set_text("Pistol Upgrade Cost: " + str(infotransfer.pistol_upgrade_cost))
	rifle_upgrade.set_text("Rifle Upgrade Cost: " + str(infotransfer.rifle_upgrade_cost))
	shotgun_upgrade.set_text("Shotgun Upgrade Cost: " + str(infotransfer.shotgun_upgrade_cost))

func _on_UpgradePistol_pressed():
	if infotransfer.money >= infotransfer.pistol_upgrade_cost:
		infotransfer.money -= infotransfer.pistol_upgrade_cost
		infotransfer.pistol_upgrade_level += 1

func _on_UpgradeRifle_pressed():
	if infotransfer.money >= infotransfer.rifle_upgrade_cost:
		infotransfer.money -= infotransfer.rifle_upgrade_cost
		infotransfer.rifle_upgrade_level += 1

func _on_UpgradeShotgun_pressed():
	if infotransfer.money >= infotransfer.shotgun_upgrade_cost:
		infotransfer.money -= infotransfer.shotgun_upgrade_cost
		infotransfer.shotgun_upgrade_level += 1

func _on_Quit_pressed():
	unpause_game()

func pause_game():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	popup.visible = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	infotransfer.game_paused = true
	game_paused = true
	if infotransfer.gun_state == "shotgun":
		infotransfer.gun_state = "rpg"

func unpause_game():
	var new_pause_state = not get_tree().paused
	popup.visible = new_pause_state
	get_tree().paused = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	infotransfer.game_paused = false
	game_paused = false
	if infotransfer.gun_state == "rpg":
		infotransfer.gun_state == "shotgun"
