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
	if infotransfer.gun_state == "rifle" and not equipped:
		$AnimationPlayer.play("rifle_equip")
		yield(get_tree().create_timer(1), "timeout")
		equipped = true
		$AnimationPlayer.play("rifle_idle")
	if not infotransfer.gun_state == "rifle" and equipped:
		$AnimationPlayer.play("rifle_unequip")
		yield(get_tree().create_timer(1), "timeout")
		equipped = false
	
	if Input.is_action_pressed("shoot") and infotransfer.gun_state == "rifle" and able_to_shoot and equipped and not out_of_ammo and not no_ammo_in_clip:
		shooting = true
		able_to_reload = false
	elif equipped and Input.is_action_just_released("shoot"): 
		shooting = false
		able_to_reload = true
		$AnimationPlayer.play("rifle_idle")

####Work on Rifle Sounds

func _process(delta): 
	if infotransfer.gun_state == "rifle" and equipped:
		if shooting and not out_of_ammo:
			$AnimationPlayer.play("rifle_shoot")
			able_to_reload = false
		if no_ammo_in_clip:
			if shooting:
				$AnimationPlayer.stop(true)
				$Armature/Ak/Sprite3D.visible = false
			shooting = false
			able_to_reload = true
		if not shooting and $Armature/Ak/Sprite3D.visible == true:
			$Armature/Ak/Sprite3D.visible = false
		if Input.is_action_just_pressed("reload") and able_to_reload:
			able_to_shoot = false
			able_to_reload = false
			$AnimationPlayer.play("rifle_reload")
			yield(get_tree().create_timer(2), "timeout")
			able_to_reload = true
			able_to_shoot = true

func _on_AnimationPlayer_animation_finished(reload):
	if reload == "rifle_shoot" and infotransfer.gun_state == "rifle" and shooting and no_ammo_in_clip:
		$AnimationPlayer.stop(true)
		shooting = false
	if reload == "rifle_shoot" and infotransfer.gun_state == "rifle" and shooting and not no_ammo_in_clip:
		$AnimationPlayer.play("rifle_shoot")
	if reload == "rifle_reload" and infotransfer.gun_state == "rifle":
		no_ammo_in_clip = false

func _on_Label3_no_ammo(va):
	out_of_ammo = true
	if va == 1:
		out_of_ammo = false

func _on_Label3_need_to_reload():
	no_ammo_in_clip = true

func _on_Label3_dont_need_to_reload_no_more():
	no_ammo_in_clip = false

