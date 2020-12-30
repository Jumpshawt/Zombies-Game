extends KinematicBody

export var tickrate = .5
var tick = 1
onready var nav = $"../../.."
onready var Player = $"../../../Player"
onready var infotransfer = $"/root/InfoTransfer"
# warning-ignore:unused_class_variable
onready var headhitbox = $"HeadHitBox"
# warning-ignore:unused_class_variable
onready var hitbox = $"HitBox"

var ammobox = preload("res://Assets/Environment/AmmoBox.tscn")

var path = []
var path_node = 0
export var speed = 0
export var MAX_SPEED = 15
export var MIN_SPEED = 5
var player_in_range = false
var random_walking = 2
var stunned = false
var health : float = 80
export var dead : bool = false
var drop_ammo_box_rng = 1 #ex 2 = 20% chance
var ammo_rng = 0

#=====AnimationStuff=====#
signal walk
signal stop_walking


#=====Sounds=====#
#signal hitsound

func _ready():
	health = health + (20 * infotransfer.round_num) * (1 + (0.1 * infotransfer.round_num))
#	print(health)
	speed = rand_range(MIN_SPEED, MAX_SPEED)
# warning-ignore:unsafe_method_access
	$Timer.start()
	var knife_damaged = get_tree().get_root().find_node("Player", true, false)
	knife_damaged.connect("knife_damage", self, "handle_knife_damage")
	
	var pistol_damaged = get_tree().get_root().find_node("Player", true, false) 
	pistol_damaged.connect("pistol_damage", self, "handle_pistol_damage")
	
	var rifle_damaged = get_tree().get_root().find_node("Player", true, false)
	rifle_damaged.connect("rifle_damage", self, "handle_rifle_damage")
	
	var shotgun_damaged = get_tree().get_root().find_node("Player", true, false)
	shotgun_damaged.connect("shotgun_damage", self, "handle_shotgun_damage")

func handle_shotgun_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 30 + (10 * infotransfer.shotgun_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
		elif self == object:
			health -= 15 + (5 * infotransfer.shotgun_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
	else:
		pass

func handle_rifle_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 75 + (25 * infotransfer.rifle_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
		elif self == object or $HitBox == object:
			health -= 40 + (10 * infotransfer.rifle_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
	else:
		pass

func handle_pistol_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 50 + (20 * infotransfer.pistol_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
		elif self == object or $HitBox == object:
			health -= 25 + (10 * infotransfer.pistol_upgrade_level)
			stun()
			infotransfer.blood_splatter = true
	else:
#		print(object)
		pass

func handle_knife_damage(object):
	if $HeadHitBox == object:
		health -= 100
		
		infotransfer.blood_splatter = true
	elif self == object or $HitBox == object:
		health -= 60
		stun()
		infotransfer.blood_splatter = true
	else: 
		pass

func player_die():
	if not dead:
		$HitBox/CollisionShape2.disabled = true
		$HeadHitBox/CollisionShape3.disabled = true
		$HitBox.queue_free()
		$HeadHitBox.queue_free()
		$"Scene Root".visible = false
		ammo_rng = rand_range(0,10)
		if ammo_rng <= drop_ammo_box_rng:
			infotransfer.money += int(rand_range(75, 125))
			infotransfer.zombies_alive -= 1
			infotransfer.blood_splatter = true
			var c = ammobox.instance()
			self.add_child(c)
#			print("box spawned")
			c.global_transform.origin = self.global_transform.origin - Vector3(0,1,0)
			c.look_at(self.global_transform.origin + Vector3(0,300,0), Vector3.UP)
			$AmmoBoxTimer.start()
		else:
			infotransfer.money += int(rand_range(75, 125))
			infotransfer.zombies_alive -= 1
			infotransfer.blood_splatter = true
			queue_free()
#func _pistol_damaged(object):
#	print("epic")

func die():
# warning-ignore:unsafe_method_access
	infotransfer.zombies_alive -= 1
	infotransfer.blood_splatter = true
	queue_free()
	#$AnimationPlayer.play("die")


# warning-ignore:unused_argument
func _process(delta):
	
	if health <= 0 and not dead:
		player_die()
		dead = true
	if infotransfer.ammo_box_collected and dead:
		queue_free()

func stun():
# warning-ignore:standalone_expression
	#emit_signal("hitsound")
	infotransfer.hitmarkersound = true
	stunned == true
	set_physics_process(false)
# warning-ignore:unsafe_method_access
	$StunTimer.start()


# warning-ignore:unused_argument
func _physics_process(delta):
	look_at(Vector3(Player.global_transform.origin.x, self.global_transform.origin.y - 10, Player.global_transform.origin.z), Vector3.UP)
	tick += 1
	if  path_node < path.size() and not dead:
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1 and not dead:
			path_node = 2
			
		
		var tickratedistance = tickrate * global_transform.origin.distance_to(Player.global_transform.origin) / 32
		
		if tick > tickratedistance * infotransfer.zombies_alive / 2:
# warning-ignore:return_value_discarded
			var prev_locat = self.global_transform 
#			print("nice")
			
			move_and_slide(direction.normalized() * tick * 8)
			
			tick = 0
			
		
	

func _quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	
	var r = q0.linear_interpolate(q1, t)
	return r

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	if path.size() > 2 and not dead:
		path[1] =  _quadratic_bezier(global_transform.origin, Vector3(global_transform.origin.x + rand_range(-2, 2),
		Player.global_transform.origin.y, global_transform.origin.z + rand_range(-2, 2)), Player.global_transform.origin, 0.05)
	
	path_node = 0 
	pass

var no_timer_spam = true

func _on_Timer_timeout():
# warning-ignore:unsafe_method_access
	$Timer.start()
	
	if player_in_range == true and not stunned and not dead:
		move_to(Vector3(Player.global_transform.origin.x + rand_range(-random_walking,
		random_walking), Player.global_transform.origin.y,
		Player.global_transform.origin.z + rand_range(-random_walking, random_walking)))
		emit_signal("walk")
		
	elif not player_in_range and no_timer_spam == true:
# warning-ignore:unsafe_method_access
		$DieTimer.start()
		no_timer_spam = false
		emit_signal("stop_walking")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
# warning-ignore:unsafe_method_access
		$DieTimer.stop()
		no_timer_spam = false

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		$DieTimer.set_wait_time(10)
# warning-ignore:unsafe_method_access
		$DieTimer.start()

func _on_StunTimer_timeout():
	stunned = false
	set_physics_process(true)

func _on_DieTimer_timeout():
	die()

func _on_AmmoBoxTimer_timeout():
	queue_free()

func _on_AmmoBox_box_collected():
#	print("hi lol")
	queue_free()
