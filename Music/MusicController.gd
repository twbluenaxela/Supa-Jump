extends Node

var title_screen_music = load("res://Music/dawudsong.wav")
var level_one_music = load("res://Music/LevelOneTheme.wav")
var level_two_music = load("res://Music/LevelTwoTheme.wav")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music(music):
	$Music.stream = music
	$Music.play()
