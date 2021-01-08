extends Spatial

onready var infotransfer = $"/root/InfoTransfer"

var able_to_reload : bool = true
var equipped : bool = false
var able_to_shoot : bool = true
var shooting : bool = false
var out_of_ammo : bool = false
var no_ammo_in_clip : bool = false

#=====SoundStuff=====#
var ShootRNG : float = 0


func _ready():
	$AnimationPlayer.play("rifle_unequip")

func _input(event):
	
	if Input.is_action_pressed("shoot") and infotransfer.gun_state == "rifle" and not infotransfer.gun_reloading and able_to_shoot and equipped and infotransfer.rifle_ammo_loaded > 0 and infotransfer.rifle_reserve_ammo > 0:
		able_to_reload = false
	elif equipped and Input.is_action_just_released("shoot"): 
		able_to_reload = true
		$AnimationPlayer.play("rifle_idle")

func equip_gun():
	if infotransfer.gun_state == "rifle" and not equipped:
		self.visible = true
		$AnimationPlayer.play("rifle_equip")
		yield(get_tree().create_timer(1), "timeout")
		equipped = true

func unequip_gun():
	if not infotransfer.gun_state == "rifle" and equipped:
		$AnimationPlayer.play("rifle_unequip")
		yield(get_tree().create_timer(1), "timeout")
		equipped = false

var reloading = false

func reload():
	if infotransfer.gun_reloading and infotransfer.gun_state == "rifle" and not reloading:
		reloading = true
		$AnimationPlayer.play("rifle_reload")
		yield(get_tree().create_timer(2), "timeout")
		reloading = false
####Work on Rifle Sounds

func _process(delta): 
	
	if not equipped and infotransfer.gun_state == "rifle":
		equip_gun()
	if equipped and not infotransfer.gun_state == "rifle":
		unequip_gun()
	if infotransfer.gun_state == "rifle" and equipped:
		if infotransfer.rifle_shooting and infotransfer.rifle_ammo_loaded > 0 and not infotransfer.gun_changing:
			$AnimationPlayer.stop(true)
			$AnimationPlayer.play("rifle_shoot")
		if infotransfer.rifle_ammo_loaded <= 0:
			if infotransfer.rifle_shooting:
				$AnimationPlayer.stop(true)
				$Armature/Ak/Sprite3D.visible = false
			able_to_reload = true
		if not shooting and $Armature/Ak/Sprite3D.visible == true:
			$Armature/Ak/Sprite3D.visible = false
		reload()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "rifle_shoot" and infotransfer.gun_state == "rifle" and infotransfer.rifle_shooting and infotransfer.rifle_ammo_loaded <= 0 or infotransfer.gun_reloading or infotransfer.gun_changing:
		$AnimationPlayer.stop(true)
		shooting = false
	if anim_name == "rifle_shoot" and infotransfer.gun_state == "rifle" and infotransfer.rifle_shooting and infotransfer.rifle_ammo_loaded > 0 and not infotransfer.gun_reloading:
		$AnimationPlayer.play("rifle_shoot")
	#if anim_name == "rifle_idle":
	#	$AnimationPlayer.play("rifle_idle")
	if anim_name == "rifle_unequip":
		self.visible = false

func _on_Label3_no_ammo(va):
	out_of_ammo = true
	if va == 1:
		out_of_ammo = false

func _on_Label3_need_to_reload():
	no_ammo_in_clip = true

func _on_Label3_dont_need_to_reload_no_more():
	no_ammo_in_clip = false

