class_name CardData

extends Resource

var card: PackedScene
var count: int
var path: String

@warning_ignore("shadowed_variable")
func _init(card: String, num: int) -> void:
	self.card = load(card)
	self.path = card
	self.count = num
