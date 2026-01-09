extends CenterContainer

var score: int = 0

@onready var _score_label: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ScoreLabel

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/ui/menu.tscn")

func set_score(new_score: int) -> void:
	score = new_score
	_score_label.text = "Score: {0}".format([score])
