extends KinematicBody


const GRAVITY = -24.8 
var vel = Vector3()
var max_speed = 8
const JUMP_SPEED = 10
const ACCEL= 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var crouched = false
var MOUSE_SENSITIVITY = 0.1
var can_stand_up = false
var able_to_stab = true

onready var camera = $"Rotation_Helper/Camera"
var rotation_helper

onready var Hud = $Control
# Recoil variables
var velocity = 0
export var gravity = 0.2
var gravity_eased = 0
export var ease_ammount = 0.25
export var kick_ammount = 0.2
export var pistol_kick_ammount = 0.2
export var shotgun_kick_ammount = 0.2
export var rifle_kick_ammount = 0.2
onready var blood_splatter = preload("res://Assets/Particles/Blood_particles.tscn")
onready var rotationhelper = $Rotation_Helper
onready var bullet_decal = preload("res://Assets/Guns/BulletHole.tscn")
onready var raycast = $"Rotation_Helper/RayCast"
onready var headbonker = $"HeadBonker"
onready var infotransfer = $"/root/InfoTransfer" 
onready var rifle_raycast = $"Rotation_Helper/Camera/RifleRayCast"
onready var interactraycast = $"Rotation_Helper/InteractRaycast"
#gun = 1 :rifle
#gun = 2 : pistol
#gun = 3 :shotgun
#gun = 4 : knife
#gun = 5 : smeg

#pistol stuff
var pistol_need_to_reload : bool = false
var reloading = false
var out_of_pistol_ammo = false
export var pistol_spread = 21

#rifle stuff

var original_cam_x
var reset_rotation = true
var out_of_rifle_ammo : bool = false
var rifle_reloading = false
var yz = 0
var zy = 0.125
var rifle_cast_position = Vector3()
var rifle_spread = false
var rifle_spread_amount = 2.75
var rifle_original_spread = Vector3(0, 0, -100)
var rifle_need_to_reload = false
var rcs = 0.02
var xddd = 0
var x = 0.5

signal bullet_hole_collider(object)
signal knife_damage(object)
signal shotgun_damage(object)
signal interacted(object)
signal rifle_damage(object)
signal pistol_damage(object)
signal reloading

#shotgun stuff
export var spread : int = 5
var shotgun_able_to_shoot : bool = true

onready var shotgunammo = $"Control/ShotgunAmmo/Label4"
onready var raycontainer = $"Rotation_Helper/ShotgunRayCastHolder"
onready var kniferaycast = $"Rotation_Helper/KnifeRaycast"

#=====AmmoBoxStuff=====#
signal shotgun_ammo
signal rifle_ammo
signal pistol_ammo
signal define_ammo_box(object)
var ammo_box_rng = 0

func _ready():
	
	original_cam_x = camera.rotation.x
	var splatter_finder = get_tree().get_root().find_node("Enemy", true, false)
	splatter_finder.connect("blood_splatter", self,"handle_blood_splatter")
	
	#var hitsound_finder = get_tree().get_root().find_node("Enemy", true, false)
	#hitsound_finder.connect("hitsound", self, "handle_hitsound")
	
	randomize()
	for r in raycontainer.get_children():
		r.cast_to.x = rand_range(-spread, spread)
		r.cast_to.y = rand_range(-spread, spread)
	
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	
	$AnimationPlayer.play("Idle")
	
	rifle_cast_position = rifle_raycast.get_cast_to()
	
	MOUSE_SENSITIVITY = 0.1
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func shoot_shotgun():
	kick_ammount = shotgun_kick_ammount
	velocity = kick_ammount
	for r in raycontainer.get_children():
		var b = bullet_decal.instance()
		r.cast_to.x = rand_range(-spread, spread)
		r.cast_to.y = rand_range(-spread, spread)
		shotgun_able_to_shoot = false
		if not r.get_collider() == null:
			r.get_collider().add_child(b)
			b.global_transform.origin = r.get_collision_point()
			b.look_at(r.get_collision_point() + r.get_collision_normal() * 100, Vector3.DOWN) 
			if r.is_colliding():
				emit_signal("shotgun_damage", r.get_collider())
				emit_signal("bullet_hole_collider", r.get_collider())

func shoot_pistol():
	if not reloading and not out_of_pistol_ammo and not pistol_need_to_reload and infotransfer.gun_state == "pistol":
		print("Pistol shoot")
		raycast.cast_to.x = rand_range(-pistol_spread, pistol_spread)
		raycast.cast_to.y = rand_range(-pistol_spread, pistol_spread)
		kick_ammount = pistol_kick_ammount
		velocity += kick_ammount / (1)
		print("shoot", velocity)
		raycast.force_raycast_update()
		var b = bullet_decal.instance()
		if not raycast.get_collider() == null:
			raycast.get_collider().add_child(b)
			b.global_transform.origin = raycast.get_collision_point()
			b.look_at(raycast.get_collision_point() + raycast.get_collision_normal() * 100, Vector3.DOWN)
			if raycast.is_colliding():
				var obj = raycast.get_collider()
				
				
				emit_signal("pistol_damage", raycast.get_collider())
				emit_signal("bullet_hole_collider", raycast.get_collider())
		else:
			pass

func shoot_rifle():
	if not rifle_reloading and not out_of_rifle_ammo and infotransfer.gun_state == "rifle" and not rifle_need_to_reload:
		$RifleSpreadTimer.stop()
		$RifleSpreadTimer.start()
		var b = bullet_decal.instance()
		if rifle_raycast.is_colliding():
			if rifle_spread == false:
				rifle_raycast.cast_to = rifle_original_spread
				rifle_spread = true
			elif rifle_spread == true:
				yield(get_tree().create_timer(0.1), "timeout")
				if x <= 1:
					x += 0.05
				
				camera.rotation.x = camera.rotation.x + lerp(0, rand_range(rcs,rcs+0.025), x)
				kick_ammount = rifle_kick_ammount
				velocity = kick_ammount
				
				#camera.rotation.x = camera.rotation.x + rand_range(-rcs,rcs)
				rifle_raycast.cast_to.x = rand_range(-rifle_spread_amount, rifle_spread_amount)
				rifle_raycast.cast_to.y = rand_range(-rifle_spread_amount, rifle_spread_amount)
			if rifle_raycast.is_colliding():
				rifle_raycast.get_collider().add_child(b)
				emit_signal("bullet_hole_collider", rifle_raycast.get_collider())
			b.global_transform.origin = rifle_raycast.get_collision_point()
			b.look_at(raycast.get_collision_point() + raycast.get_collision_normal()* 100, Vector3.DOWN)
			rifle_raycast.force_raycast_update()
			emit_signal("rifle_damage", rifle_raycast.get_collider())

func handle_blood_splatter():
	if infotransfer.blood_splatter:
		if infotransfer.gun_state == "rifle":
			var s = blood_splatter.instance()
			if rifle_raycast.is_colliding():
				rifle_raycast.get_collider().add_child(s)
				s.global_transform.origin = rifle_raycast.get_collision_point()
		if infotransfer.gun_state == "pistol":
			var y = blood_splatter.instance()
			if raycast.is_colliding():
				raycast.get_collider().add_child(y)
				y.global_transform.origin = raycast.get_collision_point()
		if infotransfer.gun_state == "shotgun":
			for r in raycontainer.get_children():
				var yos = blood_splatter.instance()
				if r.is_colliding():
					r.get_collider().add_child(yos)
					yos.global_transform.origin = r.get_collision_point()
		infotransfer.blood_splatter = false

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	handle_blood_splatter()



func process_input(delta):
	#This is process on playermovement
	pass

func process_movement(delta):
	#This is process on playermovement
	pass

func _process(delta):
	ammo_box_check()
	reset_camera_rotation()
	check_for_hitsounds()
	if headbonker.is_colliding():
		can_stand_up = false
	else:
		can_stand_up = true
	
	if reloading: 
		yield(get_tree().create_timer(1), "timeout")
		reloading = false



func _on_ReloadTimer_timeout():
	reloading = false

func _on_Label_need_to_reload():
	pistol_need_to_reload = true

func _on_PistolReloadTimer_timeout():
	pistol_need_to_reload = false

func _on_Label3_no_ammo():
	out_of_rifle_ammo = true

func reset_camera_rotation():
#	print("velocity before calculations", velocity)
	if camera.rotation.x >= 0:

		#subtract the gravity to the velocity 
#		print("calculating")
		
		
		#Checks if the velocity is less than or equal to 0, if it is  the gravity is low if not the gravity is high 
		
		if velocity <= 0:
			gravity_eased = gravity * 1 * ease_ammount
		else:
			gravity_eased = gravity * 1 * ease_ammount
		print("velocity", velocity, "velocity - gravity", velocity - (gravity_eased * camera.rotation.x))
		velocity = velocity - (gravity_eased * camera.rotation.x)
		
		
		#add velocity 
#		print(gravity * camera.rotation.x)
#		print(velocity)
		
		
		
		camera.rotation.x = velocity 
		
#		print("pre lerp",camera.rotation.x)
		
#		print("after lerp",camera.rotation.x)
	else:
		camera.rotation.x = 0
		velocity = 0

func _on_RifleSpreadTimer_timeout():
	x = 0.5
	reset_rotation = true
	rifle_spread = false
	rifle_raycast.cast_to = rifle_original_spread
	yz = 0.174

func _on_Label3_need_to_reload():
	rifle_need_to_reload = true

func _on_Label3_dont_need_to_reload_no_more():
	rifle_need_to_reload = false

func _on_ShotgunShootTimer_timeout():
	shotgun_able_to_shoot = true

#=====KnifeStabStuff=====#
func stab_knife():
	kniferaycast.force_raycast_update()
	print("stab")
	print(kniferaycast.get_collider())
	emit_signal("knife_damage", kniferaycast.get_collider())

func _on_KnifeStabTimer_timeout():
	able_to_stab = true

func check_for_hitsounds():
	if infotransfer.hitmarkersound:
		$HitSound.play()
		infotransfer.hitmarkersound = false
		$AnimationPlayer2.seek(0, true)
		$AnimationPlayer2.play("Hitmarker")

func _on_RifleReloadTimer_timeout():
	rifle_reloading = false
	rifle_need_to_reload = false

func _on_PickupArea_body_entered(body):
#	print("yes")
	if body.is_in_group("AmmoBox") and infotransfer.ammo_box_collected:
		print("signal sent")
		print(body)
		emit_signal("define_ammo_box", body)

func ammo_box_check():
	if infotransfer.ammo_box_collected == true:
		ammo_box_rng = rand_range(0,3)
		if ammo_box_rng >= 1:
			emit_signal("pistol_ammo")
		elif ammo_box_rng >= 2:
			emit_signal("rifle_ammo")
		elif ammo_box_rng >= 3:
			emit_signal("shotgun_ammo")
		infotransfer.ammo_box_collected = false
