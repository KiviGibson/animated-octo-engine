class_name SaveSystem

extends Node
var db: SQLite

@export_category("player data")
@export var try_set_cards: bool = false
func _ready() -> void:
	if "save.db" not in DirAccess.open("user://data/").get_files():
		var data_path := "res://save/base.db"
		var copy_path := "user://data/save.db"
		DirAccess.make_dir_absolute("res://save/")
		DirAccess.make_dir_absolute("user://data/")
		DirAccess.copy_absolute(data_path , copy_path)
	db = SQLite.new()
	db.path = "user://data/save.db"
	db.open_db()

func _exit_tree() -> void:
	db.close_db()

func load_state(save_id: int) -> Dictionary:
	db.query_with_bindings("""
	SELECT x, y, z FROM save WHERE id = ?;""",
	[save_id])
	var position := Vector3(
		db.query_result[0]["x"], 
		db.query_result[0]["y"],
		db.query_result[0]["z"])
	db.query_with_bindings("""
	SELECT path, hand, draw_pile, discard_pile 
	FROM save_cards INNER JOIN card ON card_id = id 
	WHERE save_id = ?;""",
	[save_id])
	var hand: Array[CardData]
	var discard: Array[CardData]
	var draw: Array[CardData]
	for dict in db.query_result:
		hand.append(CardData.new(dict["path"], dict["hand"]))
		discard.append(CardData.new(dict["path"], dict["discard_pile"])) 
		draw.append(CardData.new(dict["path"], dict["draw_pile"]))
	return {"position": position, "draw_pile": draw, "hand": hand, "discard_pile": discard}
	
func get_deck(save_id: int) -> Array[Dictionary]:
	db.query_with_bindings("""
	SELECT path, count, (hand + draw_pile + discard_pile) as in_deck
	FROM save_cards INNER JOIN card ON card_id = id
	WHERE save_id = ?;""",
	[save_id])
	var cards: Array[Dictionary]
	for dict in db.query_result:
		cards.append({
			"path": dict["path"],
			"available": dict["count"],
			"in_deck": dict["in_deck"]
		})
	return cards
func save_deck(draw: Array[CardData], hand: Array[CardData] = [], discard: Array[CardData] = [], save_id = 1) -> void:
	for card in draw:
		db.query_with_bindings("""
		UPDATE save_cards 
		SET draw_pile = ?, hand = 0, discard_pile = 0
		WHERE save_id = ? AND card_id IN (
		SELECT id FROM card WHERE path = ?); """,
		[card.count, save_id, card.path])
	for card in hand:
		db.query_with_bindings("""
		UPDATE save_cards 
		SET hand = ? 
		WHERE save_id = ? AND card_id IN (
		SELECT id FROM card WHERE path = ?); """,
		[card.count, save_id, card.path])
	for card in discard:
		db.query_with_bindings("""
		UPDATE save_cards 
		SET discard_pile = ? 
		WHERE save_id = ? AND card_id IN (
		SELECT id FROM card WHERE path = ?); """,
		[card.count, save_id, card.path])
	
func save_state() -> void:
	pass


func new_game() -> void:
	db.query("SELECT name FROM sqlite_master WHERE name != \"sqlite_sequence\"")
	if not db.query_result.is_empty():
		db.drop_table("save")
		db.drop_table("save_cards")
		db.drop_table("card")
		db.close_db()
		return

	var save_table := {
		"id":{"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"date":{"data_type": "text"},
		"x":{"data_type": "real", "not_null": true},
		"y":{"data_type": "real", "not_null": true},
		"z":{"data_type": "real", "not_null": true}
	}

	var save_cards := {
		"save_id":{"data_type": "int", "not_null": true, "foreign_key": "save.id"},
		"card_id":{"data_type": "int", "not_null": true, "foreign_key": "card.id"},
		"count":{"data_type": "int", "not_null": true},
		"draw_pile": {"data_type": "int", "not_null": true},
		"hand":{"data_type": "int", "not_null": true},
		"discard_pile": {"data_type": "int", "not_null": true}
	}

	var cards := {
		"id":{"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"path":{"data_type": "text", "not_null": true}
	}

	db.create_table("save", save_table)
	db.create_table("card", cards)
	db.create_table("save_cards", save_cards)
	if try_set_cards: set_default()

func set_default() -> void:
	for path in DirAccess.open("res://cards/cards/").get_files():
		if path.ends_with("tscn"):
			db.insert_row("card", {"path": "res://cards/cards/" + path})
	var t := Time.get_datetime_dict_from_system()
	db.insert_row("save", {
		"date": str(t.day) + "/" + str(t.month) + "/" + str(t.year) + " " + 
		str(t.hour) + ":" + str(t.minute) + ":" + str(t.second),
		"x": 0.0,
		"y": 0.0,
		"z": 0.0,
		})
	db.insert_row("save_cards",{
		"save_id": 1,
		"card_id": 1,
		"count": 10,
		"draw_pile": 5,
		"hand": 5,
		"discard_pile": 0,
	})
