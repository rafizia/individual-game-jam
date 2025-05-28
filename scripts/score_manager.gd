extends Node

var score := 0

func add_score(amount: int):
	score += amount
	#update_score_ui()

#func update_score_ui():
	#var score_label = get_node("/root/sce/UI/ScoreLabel")
	#score_label.text = "Score: %d" % score
