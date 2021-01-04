extends "res://Scripts/Player.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
