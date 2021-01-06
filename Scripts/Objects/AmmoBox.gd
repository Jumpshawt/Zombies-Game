extends Area

#=====ExternalVariables=====#
onready var infotransfer = $"/root/InfoTransfer"

func _ready():
	var playerpickup = get_tree().get_root().find_node("Player", true, false)
	playerpickup.connect("define_ammo_box", self, "handle_defined_box")
	$AnimationPlayer.play("Spin")

func handle_defined_box(eee):
	if eee == self:
		queue_free()

func _process(delta):
	self.rotation_degrees += Vector3(0,60,0) * delta
	if self.get_rotation_degrees() == Vector3(0,360,0):
		self.set_rotation_degrees(Vector3(0,0,0))

func _on_AmmoBox_body_entered(body):
	if body.is_in_group("Player"):
		infotransfer.ammo_box_collected = true
