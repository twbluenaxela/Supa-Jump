extends Node2D

onready var LEVEL_TWO_MUSIC = preload("res://Music/LevelTwoTheme.wav")

func _ready():
	MusicController.play_music(LEVEL_TWO_MUSIC)
