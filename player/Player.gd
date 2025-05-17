class_name Player
extends Unit

@export var my_deck: Array[PackedScene]
@export var camera: Camera3D
@export var container: Node3D
@export var ui: PlayerUI
signal interaction
enum states{walking, standing, dashing, running}

var draw_pile: Array[Card]
var card_index: int = 0
var hand: Array[Card]
var discard_pile: Array[Card]
var count = 0
var dash_coldown: float = 5;
var dash_timer: float = 0;
var animation_state: states
var last_direction : Vector2
# stats: health, movement speed, atack/cast speed, 

func _ready() -> void:
	GLOBAL.player = self
	prep_deck()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("atack"):
		atack()
	if Input.is_action_just_pressed("ability"):
		use(self.global_position)
	if Input.is_action_just_pressed("next"):
		next()
	if Input.is_action_just_pressed("prev"):
		prev()
	if Input.is_action_just_pressed("interact"):
		interaction.emit()
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

func prep_deck() -> void:
	draw_pile.clear()
	hand.clear()
	discard_pile.clear()
	for item in my_deck:
		var card: Card = item.instantiate()
		draw_pile.append(card)
		container.add_child(card)
	draw_pile.shuffle() 
	draw(5)

func dash() -> void:
	pass

func draw(num: int) -> void:
	for n in range(num):
		if len(draw_pile) == 0:
			shufle_cards()
		var card: Card = draw_pile.pop_back()
		ui.set_card(card, count + n)
		hand.append(card)
	count+=5
	update_selection()

func discard() -> void:
	var card: Card = hand.pop_at(card_index)
	ui.remove_card(card)
	discard_pile.append(card)
	count-=1
	if len(hand) == 0:
		draw(5)
	else:
		card_index = min(card_index, len(hand)-1)
		update_selection()

func atack() -> void:
	var throwed: bool = hand[card_index].throw(self.global_position, self.global_rotation)
	if !throwed:
		print("Cant throw right now!")
		return
	discard()

func use(my_pos: Vector3) -> void:
	var used: bool = hand[card_index].use(my_pos)
	if !used:
		print("Cant use right now!")
		return
	discard()

func shufle_cards() -> void:
	while len(discard_pile) > 0:
		draw_pile.append(discard_pile.pop_back())
	draw_pile.shuffle()

func next() -> void:
	card_index = (card_index + 1) % len(hand)
	update_selection()

func prev() -> void:
	card_index -= 1
	if card_index < 0:
		card_index = len(hand)-1
	update_selection()

func update_selection():
	var prev_arr := hand.slice(0, card_index)
	var next_arr := hand.slice(card_index + 1, len(hand))
	hand[card_index].ui_component.z_index = 10
	hand[card_index].ui_component.scale = Vector2(1.25, 1.25)
	var num = -1
	for card in next_arr:
		card.ui_component.z_index = num
		card.ui_component.scale = Vector2(.9, .9)
		num -= 1
	for card:Card in prev_arr:
		card.ui_component.z_index = num
		card.ui_component.scale = Vector2(.9, .9)
		num += 1
