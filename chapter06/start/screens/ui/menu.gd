extends Control

@onready var _highscore_label: Label = $CenterContainer/MainUIContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HighscoreLabel

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://screens/game/main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _ready():
	_highscore_label.text = str(HighscoreManager.highscore)
