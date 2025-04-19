class_name DeckComponent

extends TextureRect

@export var cost: Label
@export var card_name: Label
@export var type: Card.type
@export var text: String
@export var cost_num: int
func _process(delta: float) -> void:
	cost.text = str(cost_num)
	card_name.text = text
