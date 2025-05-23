class_name Player
extends Unit

@export var camera: Camera3D
@export var container: Node3D
@export var ui: PlayerUI
signal interaction
enum states{walking, standing, dashing, running}

var draw_pile: Array[Card]
var card_index: int = 0
var hand: Array[Card]
var discard_pile: Array[Card]
var dash_coldown: float = 5;
var dash_timer: float = 0;
var animation_state: states
var last_direction : Vector2

var targeting: Array[Unit] = []

func _ready() -> void:
	GLOBAL.player = self
	var data := SAVE_SYSTEM.load_state(1)
	self.global_position = data["position"]
	prep_deck(data["draw_pile"], data["hand"], data["discard_pile"])

func _process(_delta: float) -> void:
	if GLOBAL.current_type != GLOBAL.InputType.player:
		return
	if Input.is_action_just_pressed("atack"):
		throw()
	if Input.is_action_just_pressed("ability"):
		use(self.global_position)
	if Input.is_action_just_pressed("next"):
		next()
	if Input.is_action_just_pressed("prev"):
		prev()
	if Input.is_action_just_pressed("interact"):
		interaction.emit()

func _physics_process(_delta: float) -> void:
	if INPUT_DATA.player_direction:
		var dir := INPUT_DATA.player_direction
		last_direction = Vector2(dir.x,dir.z)
		velocity.x = dir.x * speed 
		velocity.z = dir.z * speed
		animation_state = states.running
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.y, 0, speed)
		animation_state = states.standing
	if INPUT_DATA.mouse_pos + Vector3(0, self.global_position.y, 0) != self.global_position:
		look_at(INPUT_DATA.mouse_pos + Vector3(0, self.global_position.y, 0), Vector3.UP, true)
	move_and_slide()

func prep_deck(draw_arr: Array[CardData], hand_arr: Array[CardData] = [], discard_arr: Array[CardData] = []) -> void:
	for cdata in hand_arr:
		for i in range(cdata.count):
			var c: Card = cdata.card.instantiate()
			self.container.add_child(c)
			self.draw_pile.append(c)
		draw(cdata.count)
	for cdata in discard_arr:
		for i in range(cdata.count):
			var c: Card = cdata.card.instantiate()
			self.container.add_child(c)
			self.discard_pile.append(c)
	for cdata in draw_arr:
		for i in range(cdata.count):
			var c: Card = cdata.card.instantiate()
			self.container.add_child(c)
			self.draw_pile.append(c)
	self.draw_pile.shuffle()

func remove_deck() -> void:
	for card in hand:
		ui.remove_card(card)
	for c in container.get_children():
		c.get_parent().remove_child(c)
		c.queue_free()
	self.hand.clear()
	self.draw_pile.clear()
	self.discard_pile.clear()

func dash() -> void:
	pass

func draw(num: int = 1) -> void:
	for n in range(min(num, len(draw_pile))):
		if len(draw_pile) == 0:
			shufle_cards()
		var card: Card = draw_pile.pop_back()
		ui.add_card(card)
		hand.push_back(card)
		card.draw(self.global_position, self)

func discard() -> void:
	var card: Card = hand.pop_at(card_index)
	ui.remove_card(card)
	discard_pile.append(card)
	card.discard(self.global_position, self)
	if len(hand) == 0:
		draw(5)
	else:
		card_index = min(card_index, len(hand)-1)

func throw() -> void:
	if len(hand) != 0:
		atack()
		discard()
	else:
		shufle_cards()
		draw(5)

func use(my_pos: Vector3) -> void:
	if len(hand) < 1:
		return
	if !hand[card_index].use(my_pos, self):
		print("Cant use right now!")
		return
	discard()

func shufle_cards() -> void:
	discard_pile = discard_pile.filter(func(element): return element != null)
	while len(discard_pile) > 0:
		var card: Card = discard_pile.pop_back()
		if card == null:
			continue
		draw_pile.append(card)
	draw_pile.shuffle()

func next() -> void:
	if len(hand) < 1:
		return
	card_index = (card_index + 1) % len(hand)
	ui.swap_card(1)
	print(hand[card_index].card_name + hand[card_index].name)

func prev() -> void:
	if len(hand) < 1:
		return
	card_index -= 1
	if card_index < 0:
		card_index = len(hand) - 1
	ui.swap_card(-1)
	print(hand[card_index].card_name + hand[card_index].name)
