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
	match type:
		Card.type.monsterous:
			swap_gradient("001800","037a5b")
		Card.type.basic:
			swap_gradient("361800","883900")
		Card.type.mysterious:
			swap_gradient("1f0b54","7a00ac")
		Card.type.eldrich:
			swap_gradient("202020","858585")
		Card.type.ezotheric:
			swap_gradient("171007","860002")

func swap_gradient(first:String,second:String):
	self.texture.gradient.colors[0] = Color(first, .7)
	self.texture.gradient.colors[1] = Color(second, .7)
