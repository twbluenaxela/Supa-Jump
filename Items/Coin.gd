extends Area2D
onready var audio = get_node("GetCoin")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Coin_body_entered(body):
	if visible:
		audio.play()
		visible = false
	yield(audio, "finished")
	body.get_coin()
	queue_free()


func _on_AudioStreamPlayer_finished():
	pass # Replace with function body.
