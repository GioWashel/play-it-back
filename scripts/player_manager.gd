extends Node2D

var characters = [];
# Called when the node enters the scene tree for the first time.
@onready
var activeCharacter: CharacterBody2D = $GuitarHero; 
const INACTIVE_OPACITY = 0.3
const ACTIVE_OPACITY = 1.0
const GUITAR_HERO_INDEX = 0
const DRUMER_BOY_INDEX = 1
const PIANO_MAN_INDEX = 2

func _ready() -> void:
	characters.append($GuitarHero)
	characters.append($PianoMan)
	characters.append($DrummerBoy)
	for character in characters:
		character.is_active = false
	activeCharacter.modulate.a = ACTIVE_OPACITY
	activeCharacter.is_active = true
	$DrummerBoy.modulate.a = INACTIVE_OPACITY
	$PianoMan.modulate.a = INACTIVE_OPACITY;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select_1"):
		switch_character(GUITAR_HERO_INDEX)
	elif Input.is_action_just_pressed("ui_select_2"):
		switch_character(PIANO_MAN_INDEX)
	elif Input.is_action_just_pressed("ui_select_3"):
		switch_character(DRUMER_BOY_INDEX)
		
	
	
func switch_character(index: int) -> void:
	if index < 0 || index > 2:
		return
	activeCharacter.is_active = false
	activeCharacter.modulate.a = INACTIVE_OPACITY
	activeCharacter = characters[index]
	activeCharacter.modulate.a = ACTIVE_OPACITY
	activeCharacter.is_active = true
	
	# Lower the opacity of the previously active character
 
	
	
