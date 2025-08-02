extends CharacterBody2D
class_name Player_Controller

var curr_dir : float
var primary : bool
var secondary: bool

const SPEED = 100
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 0.8
var was_airborn := false
var lockout := false

@export var action_node : Node2D

func _physics_process(delta: float) -> void:
	if lockout:
		move_and_slide();
		return
	
	if not on_floor(16):
		if not on_floor(24):
			$Sprite.play("Fall")
			was_airborn = true
		velocity += get_gravity() * delta
	else:
		was_airborn = false
	
	var direction := curr_dir
	if was_airborn == false:
		if direction != 0:
			$Sprite.play("Run")
		else:
			$Sprite.play("Idle")
	
	if direction:
		velocity.x = direction * SPEED
		$Sprite.flip_h = (velocity.x < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var previous_velocity = velocity; 
	move_and_slide();
	
func on_floor(dist : int) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2.DOWN * dist)
	query.exclude = [self]
	var res = space_state.intersect_ray(query)
	
	return not res.is_empty()

func pass_input(_dir: float, _primary: bool, _secondary: bool):
	curr_dir = _dir
	
	if (_primary and _primary != primary):
		on_primary_action()
	primary = _primary
	if (_secondary and _secondary != secondary):
		on_secondary_action()
	#Maybe add primary/secondary end?
	secondary = _secondary
	
	if primary or secondary:
		lockout = true
		$Sprite.play("Play")



func on_primary_action():
	if action_node == null:
		return
	action_node.primary_action()

func on_secondary_action():
	if action_node == null:
		return
	action_node.secondary_action()


func _on_sprite_animation_finished():
	lockout = false
	print($Sprite.animation)
