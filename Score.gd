extends Label

onready var test = get_node("/root/Player/Camera2D/HUD/Score")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_score(Global.coin_amount)
	

func set_score(value):
	value = Global.coin_amount
	self.set_text("SCORE: " + str(value))
