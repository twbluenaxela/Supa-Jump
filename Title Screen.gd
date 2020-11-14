extends Node

onready var TITLE_THEME = preload("res://Music/dawudsong.wav")

func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	MusicController.play_music(TITLE_THEME)


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()

	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Stages/StageOne.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()

