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
export var MIN_SPEED = 13
var player_in_range = false
var random_walking = 2
var stunned = false
var health : float = 80
var total_health : float = 80
export var dead : bool = false
var drop_ammo_box_rng = 2 #ex 2 = 20% chance
var ammo_rng = 0
var random_size_min = 0.3
var random_size_max = 0.5
var size_scale = null
#=====Damage=====#
var damage_dealt = 0

#=====Money=====#
var money_earned = 0

#=====Attack=====#
var player_in_attack = false
signal player_hit 

#=====AnimationStuff=====#
signal walk
signal stop_walking

#=====WalkerOrRunner=====#
var walk_or_run : float
var move_state = null

#=====Sounds=====#
var play_sound = false
var random_chance
var sound_chance = 1.0 #x out of 10
var chance_to_gurgle = 0.02 # x out of 10, called every second
var random_gurgle = 0.0


func _ready():
	random_chance = rand_range(0, 10)
	sound_chance += 2 - (infotransfer.round_num * 0.25)
	if infotransfer.round_num > 3:
		$Timer.set_wait_time(0.1 + (0.1 * infotransfer.round_num))
	if sound_chance <= 1:
		sound_chance = 1
	if random_chance <= sound_chance:
		$ZombieSpawn.play()
	size_scale = rand_range(random_size_min, random_size_max)
	self.scale = Vector3(size_scale, size_scale, size_scale)
	walk_or_run = rand_range(0, 2)
	if walk_or_run <= 1:
		move_state = "walk"
		emit_signal("walker")
	elif walk_or_run <= 2:
		move_state = "run"
		emit_signal("runner")
	
	total_health = total_health + (10 * infotransfer.round_num) #* (1 + (0.1 * infotransfer.round_num)) <- Insert if too ez
	health = total_health
	if move_state == "run":
		speed = rand_range(MIN_SPEED, MAX_SPEED)
	if move_state == "walk":
		speed = rand_range(MIN_SPEED, MAX_SPEED) * 0.2
	$Timer.start()
	var knife_damaged = get_tree().get_root().find_node("Player", true, false)
	knife_damaged.connect("knife_damage", self, "handle_knife_damage")
	
	var pistol_damaged = get_tree().get_root().find_node("Player", true, false) 
	pistol_damaged.connect("pistol_damage", self, "handle_pistol_damage")
	
	var rifle_damaged = get_tree().get_root().find_node("Player", true, false)
	rifle_damaged.connect("rifle_damage", self, "handle_rifle_damage")
	
	var shotgun_damaged = get_tree().get_root().find_node("Player", true, false)
	shotgun_damaged.connect("shotgun_damage", self, "handle_shotgun_damage")

signal walker
signal runner

func gurgle():
	random_gurgle = rand_range(0, 10)
	if random_gurgle <= chance_to_gurgle:
		$Gurgle.set_pitch_scale(rand_range(0.5, 1.5) * .2 + (size_scale * 2))
		$Gurgle.play()

func play_animation(animation_name):
	emit_signal(animation_name)

func handle_shotgun_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 40 + (20 * infotransfer.shotgun_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true
		elif self == object:
			health -= 20 + (10 * infotransfer.shotgun_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true
	else:
		pass

func handle_rifle_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 75 + (25 * infotransfer.rifle_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true
		elif self == object or $HitBox == object:
			health -= 40 + (10 * infotransfer.rifle_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true
	else:
		pass

func handle_pistol_damage(object):
	if not dead:
		if $HeadHitBox == object:
			health -= 50 + (20 * infotransfer.pistol_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true
		elif self == object or $HitBox == object:
			health -= 25 + (10 * infotransfer.pistol_upgrade_level)
			stun()
			#infotransfer.blood_splatter = true

func handle_knife_damage(object):
	if $HeadHitBox == object:
		health -= 100
		
		#infotransfer.blood_splatter = true
	elif self == object or $HitBox == object:
		health -= 60
		stun()
		#infotransfer.blood_splatter = true
	else: 
		pass

var die_animation : float
signal forwards_death
signal backwards_death

func die_animation():
	die_animation = rand_range(0,2)
	if die_animation <= 1:
		emit_signal("forwards_death")
	elif die_animation <= 2:
		emit_signal("backwards_death")

func player_die():
	if not dead:
		set_physics_process(false)
		$HitBox.queue_free()
		$HeadHitBox.queue_free()
		$CollisionShape.disabled = true
		$CollisionShape2.disabled = true
		$AttackArea.queue_free()
		$Area.queue_free()
		ammo_rng = rand_range(0,10)
		die_animation()
		if ammo_rng <= drop_ammo_box_rng:
			money_earned = int(rand_range(75, 125))
			infotransfer.money += money_earned
			infotransfer.total_money_earned += money_earned
			infotransfer.zombies_alive -= 1
			infotransfer.total_damage_dealt += total_health
			infotransfer.total_zombies_killed += 1
			var c = ammobox.instance()
			self.add_child(c)
			c.global_transform.origin = self.global_transform.origin + Vector3(0,1,0)
			c.look_at(self.global_transform.origin + Vector3(0,300,0), Vector3.UP)
			$Zombie_Die.play()
		else:
			money_earned = int(rand_range(75,125))
			infotransfer.money += money_earned
			infotransfer.total_money_earned += money_earned
			infotransfer.total_damage_dealt += total_health
			infotransfer.zombies_alive -= 1
			infotransfer.total_zombies_killed += 1
			$Zombie_Die.play()
			yield(get_tree().create_timer(4), "timeout")
			queue_free()


func die():
# warning-ignore:unsafe_method_access
	infotransfer.zombies_alive -= 1
	queue_free()
	#$AnimationPlayer.play("die")


# warning-ignore:unused_argument
func _process(delta):
	if infotransfer.zombies_alive <= 5:
		$Timer.set_wait_time(0.1)
	else:
		$Timer.set_wait_time(0.1 + (0.1 * infotransfer.round_num))
	if dead:
		set_physics_process(false)
		self.rotation = Vector3(0, self.rotation.y, 0)
	if health <= 0 and not dead:
		player_die()
		dead = true
	if infotransfer.ammo_box_collected and dead:
		for i in self.get_children():
			if i.is_in_group("AmmoBox"):
				i.queue_free()
	if not $Gurgle.is_playing() and not dead:
		gurgle()

func stun():
# warning-ignore:standalone_expression
	#emit_signal("hitsound") 
	infotransfer.hitmarkersound = true
	stunned == true
	set_physics_process(false)
# warning-ignore:unsafe_method_access
	$StunTimer.start()

func _physics_process(delta):
	look_at(Vector3(Player.global_transform.origin.x, self.global_transform.origin.y, Player.global_transform.origin.z), Vector3.UP)
	tick += 1
	if  path_node < path.size() and not dead:
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1 and not dead:
			path_node = 2
		var tickratedistance = tickrate * global_transform.origin.distance_to(Player.global_transform.origin) / 32
		if tickratedistance < 1:
			tickratedistance = 1
		if tick > tickratedistance * infotransfer.zombies_alive / 5:
			var prev_locat = self.global_transform 
			move_and_slide(direction.normalized() * tick * speed)
			tick = 0

func _quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	
	var r = q0.linear_interpolate(q1, t)
	return r

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos, true)
	path_node = 0

var no_timer_spam = true

func _on_Timer_timeout():
	if player_in_range == true and not stunned and not dead:
		move_to(Vector3(Player.global_transform.origin.x + rand_range(-random_walking,
		random_walking), Player.global_transform.origin.y,
		Player.global_transform.origin.z + rand_range(-random_walking, random_walking)))
	
	elif not player_in_range and no_timer_spam == true:
# warning-ignore:unsafe_method_access
		$DieTimer.start()
		no_timer_spam = false

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

func _on_AmmoBox_box_collected():
	queue_free()

signal attack1
signal attack2
signal kick

func attack():
	attack_chosen = rand_range(0,3)
	if attack_chosen <= 1:
		play_animation("attack1")
		$HitTimer.set_wait_time(1.3)
	elif attack_chosen <= 2:
		play_animation("attack2")
		$HitTimer.set_wait_time(1.26)
	elif attack_chosen <= 3:
		play_animation("kick")
		$HitTimer.set_wait_time(0.8)

func _on_AttackArea_body_entered(body):
	if body.is_in_group("Player"):
		player_in_attack = true
		attack()
		set_physics_process(false) #Turns off zombie
		$AttackTimer.start()  #Controls how long before zombie turns back on
		$HitTimer.start() #Controls how long till zombie hits

func _on_AttackArea_body_exited(body):
	if body.is_in_group("Player"):
		player_in_attack = false

var attack_chosen

func _on_AttackTimer_timeout():
	set_physics_process(true)
	if player_in_attack:
		attack()
		set_physics_process(false)
		yield(get_tree().create_timer(0.5), "timeout")
		$AttackTimer.start()
		$HitTimer.start()

func _on_HitTimer_timeout():
	if player_in_attack:
		infotransfer.player_hit = true 
