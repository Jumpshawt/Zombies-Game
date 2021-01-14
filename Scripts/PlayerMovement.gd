extends "res://Scripts/Player.gd"

#gun sway variables 
const SWAY = 30
onready var head = $Rotation_Helper
onready var hand = $Rotation_Helper/HandLoc/Hand
onready var handloc = $Rotation_Helper/HandLoc

func _ready():
	hand.set_as_toplevel(true)
	pass






func _process(delta):
	hand.global_transform.origin = handloc.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, SWAY * delta)
	player_hit()

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
		max_speed = 8
	elif not crouched:
		max_speed = 6
	
	#dooors
	if Input.is_action_just_pressed("interact"):
		interact()
		print("e pressed")
	
	if infotransfer.gun_state == "knife" and Input.is_action_just_pressed("shoot") and able_to_stab:
		stab_knife()
		able_to_stab = false
		$KnifeStabTimer.start()
	
	#rifle reload
	if Input.is_action_just_pressed("reload") and infotransfer.gun_state == "rifle" and not infotransfer.rifle_shooting:
		$RifleReloadTimer.start()
		reloading = true
		emit_signal("reloading")
		rifle_need_to_reload = false
	if Input.is_action_pressed("shoot") and not infotransfer.gun_reloading and not infotransfer.rifle_ammo_loaded <= 0 and infotransfer.gun_state == "rifle":
		yz += delta
		if yz >= zy:
			shoot_rifle()
			yz = 0
	if Input.is_action_just_released("shoot"):
		yield(get_tree().create_timer(0.5), "timeout")
		yz = .174 
	
	#pistol reload
	if Input.is_action_just_pressed("reload") and infotransfer.gun_reloading and infotransfer.gun_state == "pistol":
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
	
	if Input.is_action_pressed("Jump") and is_on_floor():
		vel.y = JUMP_SPEED

func process_movement(delta):
	door_popup()
	dir.y = 0
	dir = dir.normalized()
	
	if not is_on_floor():
		vel.y += GRAVITY * delta
	
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
	vel = move_and_slide(vel, Vector3(0,1,0), false)# 4, deg2rad(MAX_SLOPE_ANGLE))#move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func player_hit():
	if infotransfer.player_hit == true:
		$Ouch.play()
		fade_out = 1
		screen_shake(normal_shake_amount)
		able_to_regen = false
		$RegenTimer.start()
		damage_taken = rand_range(min_damage, max_damage)
		health -= int(damage_taken)
		infotransfer.total_damage_taken += damage_taken
		infotransfer.player_hit = false
		health_display.set_text("Health = "+ str(health))
		if health <= 50:
			$HeartBeat.play()
		if health <= 0:
			health = 0
			screen_shake(dead_shake)
			health_display.set_text("Health = "+str(health))
			player_die()

func _on_RegenTimer_timeout():
	able_to_regen = true

func _on_HeartBeat_finished():
	if health <= 50:
		$HeartBeat.play()

signal door_popup()

func door_popup():
	if interactraycast.is_colliding():
		emit_signal("door_popup", interactraycast.get_collider())
