extends Spatial

onready var infotransfer = $"/root/InfoTransfer"
var a = 1

func _ready():
	$"Round Change".play()
	$"Round Change".set_volume_db(-10)

func _process(_delta):
	if infotransfer.changing_rounds == true and a == 1:
		$"Round Change".play()
		a = 0

func _on_Round_Change_finished():
	a = 1
 
