extends Label

var ammo_loaded = 30
var reserve_ammo = 90
var x = 0
var y = 0
var z = 0.125
var reloading = false
var ShootRNG : float = 0

onready var reload_popup = $"../../ReloadPopup"
onready var infotransfer = $"/root/InfoTransfer"

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
		self.set_text(str(ammo_loaded)+" / "+str(reserve_ammo))
		if Input.is_action_pressed("shoot") and ammo_loaded > 0 and not reloading and not infotransfer.game_paused:
			y += delta
			if y >= z:
				shoot_sound()
				y = 0
				ammo_loaded -= 1

	
		if ammo_loaded <= 0 and reserve_ammo > 1:
			reload_popup.popup()
			if Input.is_action_just_pressed("reload"):
				reload_popup.hide()
				reloading = true
	

	
		if ammo_loaded <= 0:
			emit_signal("need_to_reload")
		elif ammo_loaded > 0:
			emit_signal("dont_need_to_reload_no_more")
	
		if reserve_ammo <= 0 and ammo_loaded >= 0:
			emit_signal("no_reload")
	if not infotransfer.gun_state == "rifle":
		get_parent().hide()

func _on_Player_reloading():
	reloading = true

func _on_RifleReloadTimer_timeout():
	reloading = false
	if reserve_ammo >= 30:
		x = 30 - ammo_loaded
		reserve_ammo -= x 
		ammo_loaded = 30
	elif reserve_ammo >= 0:
		if reserve_ammo + ammo_loaded <= 29:
			ammo_loaded += reserve_ammo 
			reserve_ammo = 0
		if reserve_ammo + ammo_loaded == 30:
			reserve_ammo = 0
			ammo_loaded = 30
		elif reserve_ammo + ammo_loaded >= 31 and reserve_ammo <= 30:
			x = reserve_ammo + ammo_loaded - 30
			ammo_loaded = 30
			reserve_ammo = x 


func _on_RifleSpreadTimer_timeout():
	y = 0.174

func shoot_sound():
	ShootRNG = rand_range(0,2)
	if ShootRNG <= 1:
		$"../Ak-1".set_volume_db(-15)
		#$"../Ak-1".set_pitch_scale(rand_range(1.3,1.5))
		$"../Ak-1".play()
	elif ShootRNG <= 2:
		$"../Ak-2".set_volume_db(-25)
		#$"../Ak-2".set_pitch_scale(rand_range(1.3,1.5))
		$"../Ak-2".play()
	yield(get_tree().create_timer(0.25), "timeout")


func _on_Player_rifle_ammo():
	reserve_ammo += int(rand_range(30, 60))
