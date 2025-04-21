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
func _process(_delta: float) -> void:
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
		ui.add_card(card)
		hand.append(card)
	count+=5

func discard() -> void:
	var card: Card = hand.pop_at(card_index)
	card.discarded.emit(self)
	ui.remove_card(card)
	discard_pile.append(card)
	count-=1
	if len(hand) == 0:
		draw(5)
	else:
		card_index = min(card_index, len(hand)-1)

func throw() -> void:
	atack()
	discard()

func use(my_pos: Vector3) -> void:
	if !hand[card_index].use(my_pos, self):
		print("Cant use right now!")
		return
	discard()

func shufle_cards() -> void:
	while len(discard_pile) > 0:
		draw_pile.append(discard_pile.pop_back())
	draw_pile.shuffle()

func next() -> void:
	card_index = (card_index + 1) % len(hand)
	ui.swap_card(1)

func prev() -> void:
	card_index -= 1
	if card_index < 0:
		card_index = len(hand)-1
	ui.swap_card(-1)
