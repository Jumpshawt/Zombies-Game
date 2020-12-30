extends CanvasLayer

#=====External_Variables=====#
onready var popup = $Popup
onready var infotransfer = $"/root/InfoTransfer"

#=====Script_Variables=====#
var shop_open : bool = false

#=====Signals=====#
signal rifle_ammo_bought

func _ready():
	var rifledetectthing = get_tree().get_root().find_node("RifleMachine", true, false)
	rifledetectthing.connect("rifle_shop_popup", self, "handle_shop_time")

func _process(delta):
	if Input.is_action_just_pressed("escape") and shop_open:
		resume_game()

func handle_shop_time():
	pause_game()

func _on_AmmoBuy_pressed():
	if infotransfer.money >= 1250:
		infotransfer.money -= 1250
		emit_signal("rifle_ammo_bought")

func _on_RifleBuy_pressed():
	if infotransfer.money >= 2000 and infotransfer.rifle_activated == false:
		infotransfer.money -= 2000
		infotransfer.rifle_activated = true
		$Popup/RifleBuy.set_text("Sold Out!")

func _on_Quit_pressed():
	resume_game()

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

