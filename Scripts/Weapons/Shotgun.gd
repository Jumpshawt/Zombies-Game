extends Spatial

var able_to_reload : bool = true
var able_to_shoot : bool = true
var out_of_ammo : bool = false
# warning-ignore:unused_class_variable
var cant_reload : bool = false
var equipped : bool = false
var reloading : bool = false
# warning-ignore:unused_class_variable
var out_of_reserve_ammo : bool = false

var ammo_loaded : int = 7

var zy : float = 0.5
var yz : float = 0

onready var infotransfer = $"/root/InfoTransfer"

func _ready():
# warning-ignore:unsafe_method_access
	self.visible = false
	$AnimationPlayer.play("shotgun_unequip")
	#$Shotgun_reload.set_volume_db()

func equip_shotgun():
	if infotransfer.gun_state == "shotgun" and not equipped:
		self.visible = true
		$AnimationPlayer.play("shotgun_equip")
		yield(get_tree().create_timer(0.5), "timeout")
		equipped = true

func unequip_shotgun():
	if not infotransfer.gun_state == "shotgun" and equipped:
		$AnimationPlayer.play("shotgun_unequip")
		yield(get_tree().create_timer(0.5), "timeout")
		equipped = false
# warning-ignore:unused_argument

func _process(delta):
	equip_shotgun()
	unequip_shotgun()
	if not able_to_shoot:
		yield(get_tree().create_timer(0,4), "timeout")
		able_to_shoot = true
	
	if infotransfer.gun_state == "shotgun" and equipped:
		if Input.is_action_just_pressed("shoot") and able_to_shoot and ammo_loaded > 0:
			reloading = false
			able_to_shoot = false
			able_to_reload = false
	
		if not able_to_shoot:
			yield(get_tree().create_timer(0.4), "timeout")
			able_to_shoot = true
			able_to_reload = true
	
func _on_AnimationPlayer_animation_finished(anim_name):

	#if anim_name == "reload_middle" and reloading:
	#	$AnimationPlayer.play("reload_middle")
	
	if anim_name == "shotgun_equip":
		$AnimationPlayer.stop()
	
	if anim_name == "reload_start" and reloading and not out_of_reserve_ammo:
		#$Shotgun_reload.play()
		$AnimationPlayer.play("reload_middle")
	if anim_name == "shotgun_unequip":
		self.visible = false

func _on_Label4_spin(value):
	if not $AnimationPlayer.current_animation == "reload_middle" and value == 0 and not out_of_ammo and not infotransfer.shotgun_just_shot:
		reloading = true
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("reload_start")
	elif value == 1:
		reloading = false
	elif value == 2:
		if $AnimationPlayer.current_animation == "reload_middle":
			var t = Timer.new()
			t.set_wait_time(0.5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			$Shotgun_cock.set_volume_db(-10)
			$AnimationPlayer.stop(true)
			$AnimationPlayer.play("reload_end")
			$Shotgun_cock.play()
			t.queue_free()
	elif value == 3 and $AnimationPlayer.current_animation == "reload_middle":
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("reload_end")
		$Shotgun_cock.play()

func _on_Label4_shoot():
# warning-ignore:unsafe_method_access
	$AnimationPlayer.play("shotgun_shoot")
	$FlashTimer.start()
	$Shotgun_shoot.set_volume_db(-10)
	$Shotgun_shoot.play()

func _on_Label4_out_of_reserve_ammo():
	out_of_ammo = true
	reloading = false

func _on_FlashTimer_timeout():
	$Armature/Cylinder/Sprite3D.visible = false
