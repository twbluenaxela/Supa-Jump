extends Area2D
onready var audio = get_node("GetGem")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")


func _on_Gem_body_entered(body):
	if visible:
		audio.play()
		visible = false
	yield(audio, "finished")
	body.gem_power_up()
	queue_free()


func _on_GetGem_finished():
	pass # Replace with function body.
