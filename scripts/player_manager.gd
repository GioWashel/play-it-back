extends Node2D

var characters = [];
@export var INACTIVE_OPACITY = 0.3
@export var ACTIVE_OPACITY = 1.0
var active_index : int; 
const GUITAR_HERO_INDEX = 0
const DRUMER_BOY_INDEX = 1
const PIANO_MAN_INDEX = 2

func _ready() -> void:
	characters.append($GuitarHero)
	characters.append($PianoMan)
	characters.append($DrummerBoy)
	
	active_index = GUITAR_HERO_INDEX
	
	update_opacities();

func update_opacities():
	for i in range(0, len(characters)):
		if i == active_index:
			characters[i].modulate.a = ACTIVE_OPACITY
		else:
			characters[i].modulate.a = INACTIVE_OPACITY

func get_active_character() -> Player_Controller:
	return characters[active_index]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select_1"):
		switch_character(GUITAR_HERO_INDEX)
	elif Input.is_action_just_pressed("ui_select_2"):
		switch_character(PIANO_MAN_INDEX)
	elif Input.is_action_just_pressed("ui_select_3"):
		switch_character(DRUMER_BOY_INDEX)
	
	var direction := Input.get_axis("left", "right")
	var primary_action := Input.is_action_just_pressed("primary_action")
	var secondary_action := Input.is_action_just_pressed("secondary_action")
	
	get_active_character().pass_input(direction, primary_action, secondary_action)

func switch_character(index: int) -> void:
	if index < 0 || index > 2:
		return
	active_index = index
	update_opacities()
