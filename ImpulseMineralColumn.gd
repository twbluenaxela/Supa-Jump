extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(5)
	pass # Replace with function body.


func _on_ImpulseMineralColumn_body_entered(body):
	body.impulse_launch()
	queue_free()


func _on_Timer_timeout():
	queue_free()
