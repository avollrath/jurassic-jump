extends CanvasLayer

@onready var score_label: Label = %ScoreLabel
@onready var lives_nodes: Array[TextureRect] = [$Lives/Life, $Lives/Life2, $Lives/Life3]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_score_label(score_label)
	GameManager.set_hearts(lives_nodes)
	score_label.text = "Score:" + str(GameManager.score)
