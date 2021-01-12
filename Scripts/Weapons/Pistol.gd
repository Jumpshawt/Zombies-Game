extends Spatial

export var reload_name = ""
export var shoot_name = " "
export var equip_name = " "
export var unequip_name = " "


var able_to_reload : bool = true
var able_to_shoot : bool = true
var walking : bool = false
var out_of_ammo : bool = false
var cant_reload : bool = false
var equipped : bool = false

onready var infotransfer = $"/root/InfoTransfer"

#infotransfer variables
var pistol_reloading = InfoTransfer.pistol_reloading
var pistol_ammo_loaded = InfoTransfer.pistol_ammo_loaded
var pistol_reserve_ammo = InfoTransfer.pistol_reserve_ammo



func _ready():
	self.visible = false
	$AnimationPlayer.play("unequip")

#func _input(event):
	#if Input.is_action_just_released("2"):
		#print("pressed 2")
		#print(equipped)
		#pass
	#if Input.is_action_just_released("2") and not equipped:
#		self.visible = true
		#print("equiping")
		#$AnimationPlayer.play("equip")
		#yield(get_tree().create_timer(1), "timeout")
		#equipped = true

func equip_pistol():
	if not equipped and infotransfer.gun_state == "pistol":
		self.visible = true
		equipped = true
		$AnimationPlayer.play("equip")
		yield(get_tree().create_timer(1, false), "timeout")


func unequip_pistol():
	if equipped and not infotransfer.gun_state == "pistol":
		$AnimationPlayer.play("unequip")
		yield(get_tree().create_timer(1, false), "timeout")
		equipped = false

func _process(delta):
	equip_pistol()
	unequip_pistol()
	
	#if not infotransfer.gun_state == "pistol" and equipped and infotransfer.gun_changing == true:
		#print("unequiping pistol")
		#$AnimationPlayer.play("unequip")
		#yield(get_tree().create_timer(1), "timeout")
		#self.visible = false
		#equipped = false
	if infotransfer.gun_state == "pistol" and equipped:
		if Input.is_action_just_pressed("shoot") and !InfoTransfer.pistol_ammo_loaded == 0:
			$AnimationPlayer.stop(true)
			#print(InfoTransfer.pistol_ammo_loaded)
			#print(InfoTransfer.pistol_ammo_loaded == 0)
			$AnimationPlayer.play("shoot")
			able_to_shoot = true 
			able_to_reload = false
			$Pistol_Fire.set_volume_db(-20)
			$Pistol_Fire.play()
		elif Input.is_action_just_pressed("shoot") and InfoTransfer.pistol_ammo_loaded == 0:
			$No_Ammo.play()
			#print("out of ammo")
		if Input.is_action_just_pressed("reload") and able_to_reload and not cant_reload:
			$AnimationPlayer.play("reload")
			yield(get_tree().create_timer(0.47), "timeout")
			$Pistol_Reload_1.set_volume_db(-10)
			$Pistol_Reload_1.play()
			able_to_reload = false
			able_to_shoot = false
		if not able_to_reload:
			yield(get_tree().create_timer(0.2), "timeout")
			able_to_reload = true


func _on_Label_no_reload(help):
	if help == 1:
		cant_reload = true
	elif help == 0:
		cant_reload = false
#
func _on_Label_no_ammo(eee):
	if eee == 1:
		out_of_ammo = false
	else:
		out_of_ammo = true

func _on_Label_need_to_reload():
	able_to_shoot = false
	out_of_ammo = true
	#print('recived signal')

func _on_AnimationPlayer_animation_finished(Animation_name):
	if Animation_name == "reload":
		#print("finished reload")
		out_of_ammo = false
		able_to_shoot = true
	if Animation_name == "equip":
		$AnimationPlayer.stop()
		
	if Animation_name == "unequip":
		self.visible = false
		able_to_shoot = false
#	if Animation_name == "equip":
	#	self.visible = true
	#	able_to_shoot = false
	#	yield(get_tree().create_timer(1), "timeout")
	able_to_shoot = true
