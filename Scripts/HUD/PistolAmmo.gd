extends Label

onready var reload_popup = $"../../ReloadPopup"
onready var infotransfer = $"/root/InfoTransfer"
onready var pistol_ammo_popup = $".."

var x = 0

signal no_reload
signal need_to_reload
signal no_ammo

func _ready():
	var pistol_ammo_bought = get_tree().get_root().find_node("PistolShopScreen", true, false)
	pistol_ammo_bought.connect("pistol_ammo_bought", self, "handle_ammo_bought")

func handle_ammo_bought():
	InfoTransfer.pistol_reserve_ammo += 90
	emit_signal("no_ammo", 1)

func _process(delta):
	if infotransfer.gun_state == "pistol":
		if InfoTransfer.pistol_ammo_loaded <= 0:
			emit_signal("need_to_reload")
		pistol_ammo_popup.popup()
		if Input.is_action_just_pressed("shoot") and InfoTransfer.pistol_ammo_loaded > 0 and not infotransfer.game_paused:
			InfoTransfer.pistol_ammo_loaded -= 1
		self.set_text(str(InfoTransfer.pistol_ammo_loaded)+" / "+str(InfoTransfer.pistol_reserve_ammo))
		if InfoTransfer.pistol_ammo_loaded <= 3 and InfoTransfer.pistol_reserve_ammo > 1 or not infotransfer.gun_state == "pistol":
			reload_popup.popup()
			if Input.is_action_just_pressed("reload"):
				reload_popup.hide()

		if InfoTransfer.pistol_reserve_ammo <= 0 and InfoTransfer.pistol_ammo_loaded >= 0:
			emit_signal("no_reload", 1)
		elif InfoTransfer.pistol_reserve_ammo >= 0:
			emit_signal("no_reload", 0)
	if not infotransfer.gun_state == "pistol": 
		pistol_ammo_popup.hide()
	if InfoTransfer.pistol_reloading:
		yield(get_tree().create_timer(1, false), "timeout")
		InfoTransfer.pistol_reloading = false

func _on_PistolReloadTimer_timeout():
	InfoTransfer.pistol_reloading = false
	if InfoTransfer.pistol_reserve_ammo >= 16:
		x = 16 - InfoTransfer.pistol_ammo_loaded
		InfoTransfer.pistol_reserve_ammo -= x 
		InfoTransfer.pistol_ammo_loaded = 16
	elif InfoTransfer.pistol_reserve_ammo >= 0:
		if InfoTransfer.pistol_reserve_ammo + InfoTransfer.pistol_ammo_loaded <= 15:
			InfoTransfer.pistol_ammo_loaded += InfoTransfer.pistol_reserve_ammo 
			InfoTransfer.pistol_reserve_ammo = 0
		if InfoTransfer.pistol_reserve_ammo + InfoTransfer.pistol_ammo_loaded == 16:
			InfoTransfer.pistol_reserve_ammo = 0
			InfoTransfer.pistol_ammo_loaded = 16
		elif InfoTransfer.pistol_reserve_ammo + InfoTransfer.pistol_ammo_loaded >= 17 and InfoTransfer.pistol_reserve_ammo <= 16:
			x = InfoTransfer.pistol_reserve_ammo + InfoTransfer.pistol_ammo_loaded - 16
			InfoTransfer.pistol_ammo_loaded = 16
			InfoTransfer.pistol_reserve_ammo = x 


func _on_Player_pistol_ammo():
	InfoTransfer.pistol_reserve_ammo += int(rand_range(16, 32))
