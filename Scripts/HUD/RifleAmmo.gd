extends Label

onready var reload_popup = $"../../ReloadPopup"
onready var infotransfer = $"/root/InfoTransfer"

var ammo_loaded : int#= infotransfer.rifle_ammo_loaded
var reserve_ammo : int#= infotransfer.rifle_reserve_ammo
var x = 0
var y = 0
var z = 0.125
var reloading = false
var ShootRNG : float = 0

signal no_reload
signal need_to_reload
signal no_ammo
signal dont_need_to_reload_no_more

func _ready():
	var ammo_bought = get_tree().get_root().find_node("RifleShopScreen", true, false)
	ammo_bought.connect("rifle_ammo_bought", self, "handle_ammo_bought")

func handle_ammo_bought():
	reserve_ammo += 150

func _process(delta):
	if infotransfer.gun_state == "rifle":
		get_parent().popup()
		self.set_text(str(infotransfer.rifle_ammo_loaded)+" / "+str(infotransfer.rifle_reserve_ammo))
		if infotransfer.rifle_shooting and not infotransfer.game_paused and infotransfer.rifle_ammo_loaded > 0:
			y += delta
			if y >= z:
				shoot_sound()
				y = 0
				infotransfer.rifle_ammo_loaded -= 1
	
		if infotransfer.rifle_ammo_loaded <= 5 and infotransfer.rifle_reserve_ammo > 1:
			reload_popup.popup()
			if Input.is_action_just_pressed("reload") and not infotransfer.rifle_shooting:
				reload_popup.hide()
	
		if infotransfer.rifle_ammo_loaded <= 0:
			emit_signal("need_to_reload")
		elif infotransfer.rifle_ammo_loaded > 0:
			emit_signal("dont_need_to_reload_no_more")
	
		if infotransfer.rifle_reserve_ammo <= 0 and infotransfer.rifle_ammo_loaded >= 0:
			emit_signal("no_reload")
	if not infotransfer.gun_state == "rifle":
		get_parent().hide()

func _on_Player_reloading():
	#infotransfer.gun_reloading = true
	pass



func _on_RifleReloadTimer_timeout():
	if infotransfer.rifle_reserve_ammo >= 30:
		x = 30 - infotransfer.rifle_ammo_loaded
		infotransfer.rifle_reserve_ammo -= x 
		infotransfer.rifle_ammo_loaded = 30
	elif infotransfer.rifle_reserve_ammo >= 0:
		if infotransfer.rifle_reserve_ammo + infotransfer.rifle_ammo_loaded <= 29:
			infotransfer.rifle_ammo_loaded += infotransfer.rifle_reserve_ammo 
			infotransfer.rifle_reserve_ammo = 0
		if infotransfer.rifle_reserve_ammo + infotransfer.rifle_ammo_loaded == 30:
			infotransfer.rifle_reserve_ammo = 0
			infotransfer.rifle_ammo_loaded = 30
		elif infotransfer.rifle_reserve_ammo + infotransfer.rifle_ammo_loaded >= 31 and infotransfer.rifle_reserve_ammo <= 30:
			x = infotransfer.rifle_reserve_ammo + infotransfer.rifle_ammo_loaded - 30
			infotransfer.rifle_ammo_loaded = 30
			infotransfer.rifle_reserve_ammo = x 


func _on_RifleSpreadTimer_timeout():
	y = 0.174

func shoot_sound():
	ShootRNG = rand_range(0,2)
	if ShootRNG <= 1:
		$"../Ak-1".set_volume_db(-15)
		$"../Ak-1".play()
	elif ShootRNG <= 2:
		$"../Ak-2".set_volume_db(-25)
		$"../Ak-2".play()
	yield(get_tree().create_timer(0.25), "timeout")


func _on_Player_rifle_ammo():
	infotransfer.rifle_reserve_ammo += int(rand_range(30, 60))
