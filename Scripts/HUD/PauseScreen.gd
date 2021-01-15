extends CanvasLayer

#=====External Stuff=====#
onready var infotransfer = $"/root/InfoTransfer"

#=====Script Variables=====#
var able_to_pause : bool = true
var paused : bool = false
var paused_on_my_terms :bool = false
#=====Code.jpg=====#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause_check():
	if infotransfer.game_paused:
		paused = true
		able_to_pause = false
	elif infotransfer.game_paused == false:
		paused = false
		able_to_pause = true
		paused_on_my_terms = false


# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("escape") and not paused and able_to_pause:
		pause_game()
	elif Input.is_action_just_pressed("escape") and paused and paused_on_my_terms:
		resume_game()
	pause_check()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Resume_pressed():
	resume_game()
	paused = false

func resume_game():
	var new_pause_state = not get_tree().paused
	$Popup.visible = new_pause_state
	get_tree().paused = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	infotransfer.game_paused = false
	if infotransfer.gun_state == "rpg":
		infotransfer.gun_state = "shotgun"

func pause_game():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	$Popup.visible = new_pause_state
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	infotransfer.game_paused = true
	paused_on_my_terms = true
	if infotransfer.gun_state == "shotgun":
		infotransfer.gun_state == "rpg"
		
