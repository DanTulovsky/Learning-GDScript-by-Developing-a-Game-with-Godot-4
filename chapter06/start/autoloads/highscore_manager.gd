extends Node

var highscore: int = 0

func set_new_highscore(new_highscore: int) -> void:
	if new_highscore > highscore:
		highscore = new_highscore
