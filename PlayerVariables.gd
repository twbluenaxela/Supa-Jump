extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_vars = get_node("/root/PlayerVariables")
var can_use_anti_grav_mineral = false
var can_use_impulse_mineral = false
var fireball_power = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
