extends Area2D


func _ready():
	pass # Replace with function body.



func _on_WorldBorder_body_entered(body):
	if "Player" in body.name:
		body.dead()
