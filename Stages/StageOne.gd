extends Node2D

onready var LEVEL_ONE_MUSIC = preload("res://Music/LevelOneTheme.wav")


func _ready():
	MusicController.play_music(LEVEL_ONE_MUSIC)

