class_name CardData

extends Resource

var card: PackedScene
var count: int

@warning_ignore("shadowed_variable")
func _init(card: String, num: int) -> void:
	self.card = load(card)
	self.count = num
