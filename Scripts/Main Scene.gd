extends Spatial

onready var infotransfer = $"/root/InfoTransfer"
var a = 1

func _ready():
	print("start")
	$"Round Change".play()
	$"Round Change".set_volume_db(-20)

func _process(_delta):
	if infotransfer.changing_rounds == true and a == 1:
		$"Round Change".play()
		a = 0
	if a == 0:
		yield(get_tree().create_timer(10, true), "timeout")
		a = 1
