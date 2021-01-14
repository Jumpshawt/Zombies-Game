extends Label

onready var ShotgunAmmoPopup = self.get_parent()
onready var infotransfer = $"/root/InfoTransfer"
onready var need_to_reload_popup = $"../../ReloadPopup"
onready var shotguntimer = $"../../../ShotgunShootTimer"
onready var shotgun_reload = $"../Shotgun_reload"

var ammo_loaded : int = 7
var max_ammo_loaded : int = 7
var reserve_ammo : int = 28

var able_to_shoot : bool = true
var able_to_reload : bool = true
var reloading : bool = false
var already_emitted_signal : bool = false
var help : bool = true

var reloadallow = false

var x : float = 0
var y : float = 0.5

# warning-ignore:unused_class_variable
var z : float = 0
# warning-ignore:unused_class_variable
var xz : float = 0.5

signal out_of_reserve_ammo
signal spin 
signal shoot

func _ready():
	var ammo_bought = get_tree().get_root().find_node("ShotgunShopScreen", true, false)
	ammo_bought.connect("shotgun_ammo_bought", self, "handle_ammo_bought")

func handle_ammo_bought():
	reserve_ammo += 28

# warning-ignore:unused_argument
func _input(event):
	if infotransfer.gun_state == "shotgun":
		ShotgunAmmoPopup.popup()
		if Input.is_action_just_pressed("shoot") and able_to_shoot and ammo_loaded > 0 and infotransfer.game_paused == false:
			shotguntimer.start()
			emit_signal("shoot")
			able_to_shoot = false
			able_to_reload = false
			reloading = false
		elif Input.is_action_just_pressed("reload") and able_to_reload and reserve_ammo > 0 and ammo_loaded < 7 and not infotransfer.shotgun_just_shot:
			emit_signal("spin", 0)
			reloading = true
			able_to_reload = false
		
	else:
		ShotgunAmmoPopup.hide()
	
func _process(delta):
	self.set_text(str(ammo_loaded) + " / " + str(reserve_ammo))
	 
#	if reserve_ammo <= 0:
#		emit_signal("out_of_reserve_ammo", 0)
#		already_emitted_signal = true
#
#	elif reserve_ammo >= 0 and already_emitted_signal:
#		emit_signal("out_of_reserve_ammo", 1)
#
	if not reloading:
		emit_signal("spin", 1)
	
	if ammo_loaded == max_ammo_loaded:
		#emit_signal("spin", 2)
		pass
	
	if reloading and ammo_loaded < max_ammo_loaded and reserve_ammo > 0:
		able_to_reload = false
		if not reloadallow:
			yield(get_tree().create_timer(0.3), "timeout")
			reloadallow = true
		if reloadallow:
			x += delta
			if x >= y:
				shotgun_reload.play()
				ammo_loaded += 1
				reserve_ammo -= 1
				x = 0
	if not able_to_reload:
		able_to_reload = true
	else:
		able_to_reload = true
	if ammo_loaded <= 1:
		need_to_reload_popup.popup()
	else:
		need_to_reload_popup.hide()

func _on_ShotgunShootTimer_timeout():
	able_to_shoot = true


func _on_HalfSecond_Timer_timeout():
	if ammo_loaded == 6:
		emit_signal("spin", 2)
	if ammo_loaded == 7:
		emit_signal("spin", 3)


func _on_Player_shotgun_ammo():
	reserve_ammo += int(rand_range(14,21))
