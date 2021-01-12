extends CanvasLayer

#=====EXTERNAL_STUFF=====#
onready var infotransfer = $"/root/InfoTransfer"
onready var popup = $Popup

#=====Script Variables=====#
var shop_open : bool = false

#=====PRICES=====#
var pistol_price = 500
var pistol_ammo_price = 500

#=====SIGNALS=====#
#Amount of Ammo can be found in pistol HUD
signal pistol_ammo_bought

#=====USELESS_CODE_DONT_TOUCH=====#
func _process(_delta):
	if infotransfer.pistol_activated == true:
		$Popup/PistolBuy.set_text("No need for this button")
	if infotransfer.game_paused == true and Input.is_action_just_pressed("escape") and shop_open:
		resume_game()

func _ready():
	var detectopenshop = get_tree().get_root().find_node("PistolMachine", true, false)
	detectopenshop.connect("pistol_shop_popup", self, "handle_shop_opened")
	$Popup/AmmoBuy.set_text("Buy 90 Pistol Ammo: Price = 500")

func handle_shop_opened():
	if infotransfer.game_paused == false:
		popup.visible
		pause_game()

func _on_AmmoBuy_pressed():
	if infotransfer.money >= pistol_price and infotransfer.pistol_activated:
		infotransfer.money -= pistol_ammo_price
		emit_signal("pistol_ammo_bought")

func _on_PistolBuy_pressed():
	if infotransfer.money >= pistol_price and not infotransfer.pistol_activated:
		infotransfer.money -= pistol_price
		infotransfer.pistol_activated = true
		$Popup/PistolBuy.set_text("Sold Out!")

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

