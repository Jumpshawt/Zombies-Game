extends Spatial

#=====External_Variables=====#
onready var infotransfer = $"/root/InfoTransfer"

#=====Script_Variables=====#
var equipped : bool = false
var stabbing : bool = false
var equipping: bool = false

func _ready():
	$AnimationPlayer.play("knife_unequip")

func _process(delta):
	knife_animations()

func knife_animations():
	if infotransfer.gun_state == "knife":
		if not equipped:
			$AnimationPlayer.play("knife_equip")
		if Input.is_action_just_pressed("shoot") and equipped:
			$AnimationPlayer.play("knife_stab")
			stabbing = true
			$StabTimer.start()
		elif equipped and stabbing == false:
			$AnimationPlayer.play("knife_idle")
	elif equipped:
		$AnimationPlayer.play("knife_unequip")
		equipped = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "knife_idle":
		$AnimationPlayer.play("knife_idle")
	if anim_name == "knife_equip":
		$AnimationPlayer.play("knife_idle")
		equipped = true

func _on_StabTimer_timeout():
	stabbing = false

func _on_EquipTimer_timeout():
	equipping = false
