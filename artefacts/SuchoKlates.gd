class_name SuchoKlates

extends Health

var card: PackedScene = load("res://cards/throw cards/Wound.tscn")

func _ready() -> void:
	max_health = 120
	super._ready()
	
func change_health(value:int) -> void:
	var player: Node3D = get_parent()
	if player is Player:
		for i in range(0, int(value/10.0)):
			var created: Card = card.instantiate()
			var stats: Harm = created.get_child(0)
			stats.amount = int((value/10.0)) + 4
			stats.player = player
			player.draw_pile.append(created)
			player.add_child(created)
			
func is_wound(c: Card) -> bool:
	return c.card_name == "Wound"
			
func wounds_of_glory() -> void:
	var player: Node3D = get_parent()
	if player is Player:
		var cards: Array[Card] = player.draw_pile.filter(is_wound)
		player.draw_pile = player.draw_pile.filter(!is_wound)
		for c in cards:
			c.queue_free()

func card_interaction(value:int) -> void:
	super.change_health(value)
