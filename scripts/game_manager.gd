extends Node

@onready var score_label: Label = %ScoreLabel

var score = 0

func add_points(points):
	score += points
	score_label.text = "Score: " + str(score)
