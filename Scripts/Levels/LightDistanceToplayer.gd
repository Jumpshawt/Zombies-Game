extends OmniLight

#this shit is the stuff that is how far you need to be away from the light for it to turn off 
export var distance_to_player_cutoff = 50
export var is_shadow = true
export var shadow_distance = 10
#accesses the player ( ITS NOT WORKING RN LOL
onready var Player = $"../../../../Player"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	#P
	if global_transform.origin.distance_to(Player.global_transform.origin) < distance_to_player_cutoff:
		print("light visible")
		self.visible = true 
	else:
		self.visible = false
		self.visible == false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
