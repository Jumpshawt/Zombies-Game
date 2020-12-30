extends CanvasLayer

#=====ExternalValues=====#
onready var infotransfer = $"/root/InfoTransfer"
onready var popup = $Popup

#=====ScriptVariables=====#
var shop_open : bool = false

#=====Signals=====#
signal shotgun_ammo_bought

func _ready():
	var open_shop = get_tree().get_root().find_node("ShotgunMachine", true, false)
	open_shop.connect("shotgun_shop_popup", self, "handle_shop_open")

func _process(delta):
	if Input.is_action_just_pressed("escape") and shop_open:
		resume_game()

func handle_shop_open():
	pause_game()

func pause_game():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	popup.visible = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#emit_signal("paused", 0)
	infotransfer.game_paused = true
	shop_open = true
	if infotransfer.gun_state == "shotgun":
		infotransfer.gun_state = "rpg"

func resume_game():
	var new_pause_state = not get_tree().paused
	popup.visible = new_pause_state
	get_tree().paused = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#emit_signal("paused", 1)
	infotransfer.game_paused = false
	shop_open = false
	if infotransfer.gun_state == "rpg":
		infotransfer.gun_state == "shotgun"

func _on_Buy_Shotgun_pressed():
	if infotransfer.money >= 2500 and infotransfer.shotgun_activated == false:
		infotransfer.money -= 2500
		infotransfer.shotgun_activated = true
		$"Popup/Buy Shotgun".set_text("Sold Out!")

func _on_Quit_pressed():
	resume_game()

func _on_Buy_Ammo_pressed():
	if infotransfer.money >= 1250:
		infotransfer.money -= 1250
		emit_signal("shotgun_ammo_bought")
