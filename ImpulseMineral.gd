extends Area2D

onready var audio = get_node("MineralGrab")


func _ready():
	pass # Replace with function body.


func _on_MineralGrab_finished():
	pass # Replace with function body.


func _on_ImpulseMineral_body_entered(body):
	if visible:
		audio.play()
		visible = false
	yield(audio, "finished")
	body.activate_impulse_mineral_power_up()
	queue_free()
