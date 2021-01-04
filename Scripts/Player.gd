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
var gravity = 1
var gravity_eased = 0
var ease_ammount = 0.1
var kick_ammount = 0.5
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
	camera.rotation.x = camera.rotation.x + rand_range(rcs + 0.1,rcs+0.3)
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
		raycast.cast_to.x = rand_range(-pistol_spread, pistol_spread)
		raycast.cast_to.y = rand_range(-pistol_spread, pistol_spread)
		velocity = kick_ammount
		#print("shoot", velocity)
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
				velocity == kick_ammount
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
	
	if Input.is_action_just_pressed("shoot") and infotransfer.gun_state == "shotgun" and shotgunammo.ammo_loaded >= 1 and shotgun_able_to_shoot:
		shoot_shotgun()

	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("W"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("S"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("A"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("D"):
		input_movement_vector.x = 1
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("W") and Input.is_action_pressed("S") == false and not crouched:
		max_speed = 15
	elif not crouched:
		max_speed = 8
	
	#dooors
	if Input.is_action_just_pressed("interact"):
		interactraycast.force_raycast_update()
		emit_signal("interacted", interactraycast.get_collider())
	
	if infotransfer.gun_state == "knife" and Input.is_action_just_pressed("shoot") and able_to_stab:
		stab_knife()
		able_to_stab = false
		$KnifeStabTimer.start()
	
	#rifle reload
	if Input.is_action_just_pressed("reload") and infotransfer.gun_state == "rifle" and not reloading:
		$RifleReloadTimer.start()
		reloading = true
		emit_signal("reloading")
		rifle_need_to_reload = false
	if Input.is_action_pressed("shoot") and not rifle_reloading and not rifle_need_to_reload and infotransfer.gun_state == "rifle":
		yz += delta
		if yz >= zy:
			shoot_rifle()
			yz = 0
	if Input.is_action_just_released("shoot"):
		yield(get_tree().create_timer(0.25), "timeout")
		reset_rotation = true
	
	#pistol reload
	if Input.is_action_just_pressed("reload") and not reloading and infotransfer.gun_state == "pistol":
		$PistolReloadTimer.start()
		emit_signal("reloading")
		reloading = true
	if Input.is_action_just_pressed("shoot") and not reloading and infotransfer.gun_state == "pistol":
		shoot_pistol()
	
	#crouching
	if Input.is_action_just_pressed("crouch") and not crouched:
		crouched = true
		max_speed = 6
		$AnimationPlayer.play("Crouch")
		$AnimationPlayer.playback_speed = 4 
	elif Input.is_action_just_pressed("crouch") and crouched and can_stand_up:
		crouched = false
		max_speed = 6
		$AnimationPlayer.play("UnCrouch")
		$AnimationPlayer.playback_speed = 4 
	#movement
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		vel.y = JUMP_SPEED

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta*GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= max_speed

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

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

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

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
#		var velocity = 0
#		var gravity = 0.1
#		var ease_ammount = 0
#		var kick_ammount = 1
		#subtract the gravity to the velocity 
#		print("calculating")
		
		gravity_eased = gravity * camera.rotation.x * 10
		#print("gravity_eased", gravity_eased, "gravity", gravity)
		velocity = velocity - (gravity_eased * camera.rotation.x)
		#add velocity 
#		print(gravity * camera.rotation.x)
#		print(velocity)
		camera.rotation.x += velocity * 0.1
		#print("pre lerp",camera.rotation.x)
		camera.rotation.x = lerp(camera.rotation.x, -0, 0.1)
		#print("after lerp",camera.rotation.x)
		if camera.rotation.x == original_cam_x:
			#reset_rotation = false
			pass
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
	#print("stab")
	#print(kniferaycast.get_collider())
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
