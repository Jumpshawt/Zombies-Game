extends Spatial

onready var infotransfer = $"/root/InfoTransfer"
var a = 1

func _ready():
	print("start")
	$"Round Change".set_volume_db(150)

func _process(delta):
	if infotransfer.changing_rounds == true and a == 1:
		$"Round Change".play()
		a = 0
	if a == 0:
		var t = Timer.new()
		t.set_wait_time(10)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		a = 1


func _on_Enemy2_stop_walking():
	pass # Replace with function body.


func _on_Enemy2_walk():
	pass # Replace with function body.
