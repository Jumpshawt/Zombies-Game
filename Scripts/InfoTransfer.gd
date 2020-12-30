extends Spatial

#====GAME_STUFF====#
# warning-ignore:unused_class_variable
var round_paused : bool = false
# warning-ignore:unused_class_variable
var a = 0
# warning-ignore:unused_class_variable
var game_paused : bool = false
var ammo_box_collected : bool = false

#=====GUN_STUFF=====#
var gun_state = "unarmed"
#[unarmed, shotgun, pistol, rifle, rpg, smg, knife]

var pistol_activated = false
var rifle_activated = false
var shotgun_activated = false

var gun_reloading = false

var gun_changing : bool = false

#=====ZOMBIE_SPAWNER=====#
var x = 0
var y = 100
export var round_num = 5
var zombies_to_spawn = [0, 3, 4, 6, 9, 12, 13, 14, 14, 15,
16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 25, 25, 25, 25,
25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,
25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,
25, 25] 
var hordes_to_spawn = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5]
var zombies_alive = 1
var spawn_zombies = true
var changing_rounds = false

var fixme = true

#=====UPGRADES======#
var pistol_upgrade_level = 0
var pistol_upgrade_cost : float = 1000
var pistol_increase_amount : float = 1500
var rifle_upgrade_level = 0
var rifle_upgrade_cost : float = 2000
var rifle_increase_amount : float = 2000
var shotgun_upgrade_level = 0
var shotgun_upgrade_cost : float = 2000
var shotgun_increase_amount : float = 2000

# warning-ignore:unused_class_variable
var money = 100000

#=====Particles=====#
var blood_splatter = false

#=====Sounds=====#
var hitmarkersound = false

#=====ACTUAL_CODE=====#
func _ready():
	pass
# warning-ignore:unused_argument
func _input(event):
	if gun_changing:
		yield(get_tree().create_timer(1), "timeout")
		gun_changing = false
	
	if Input.is_action_just_pressed("reload") and not gun_state == "rifle":
		gun_reloading = true
		yield(get_tree().create_timer(1), "timeout")
		gun_reloading = false
	elif Input.is_action_just_pressed("reload") and gun_state == "rifle":
		gun_reloading = true
		yield(get_tree().create_timer(2), "timeout")
		gun_reloading = false
	if Input.is_action_just_pressed("1") and not gun_state == "rifle" and not gun_reloading and not gun_changing and rifle_activated:
		gun_state = "rifle"
		gun_changing = true
	
	if Input.is_action_just_pressed("2") and not gun_state == "pistol" and not gun_reloading and not gun_changing and pistol_activated:
		gun_state = "pistol"
		gun_changing = true
	
	if Input.is_action_just_pressed("3") and not gun_state == "shotgun" and not gun_reloading and not gun_changing and shotgun_activated:
		gun_state = "shotgun"
		gun_changing = true
	
	if Input.is_action_just_pressed("4") and not gun_state == "knife" and not gun_reloading and not gun_changing:
		gun_state = "knife"
		gun_changing = true
	
	if Input.is_action_just_pressed("5") and not gun_state == "rpg" and not gun_reloading and not gun_changing:
		gun_state = "rpg"
		gun_changing = true

func _process(delta):
	update_prices()
	if zombies_alive == zombies_to_spawn[round_num]:
		spawn_zombies = false
	if zombies_alive <= 0 and spawn_zombies == false and fixme:
		fixme = false
		yield(get_tree().create_timer(5), "timeout")
		spawn_zombies = true
		round_num += 1
		changing_rounds = true
		x = 0
	x += delta
	if x >= y:
		x = 0 
		round_num += 1
		spawn_zombies = true
		changing_rounds = true
	if changing_rounds:
		yield(get_tree().create_timer(1), "timeout")
		changing_rounds = false
	if fixme == false:
		yield(get_tree().create_timer(5), "timeout")
		fixme = true 

func update_prices():
	pistol_upgrade_cost = 1000 + (pistol_increase_amount * pistol_upgrade_level)
	rifle_upgrade_cost = 2000 + (rifle_increase_amount * rifle_upgrade_level)
	shotgun_upgrade_cost = 2000 + (shotgun_increase_amount * shotgun_upgrade_level)
