extends CharacterBody2D
class_name Player_Controller

var curr_dir : float
var primary : bool
var secondary: bool

const SPEED = 100
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 0.8

@export var action_node : Node2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not on_floor():
		velocity += get_gravity() * delta
	# player selected	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := curr_dir
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = (velocity.x < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var previous_velocity = velocity; 
	move_and_slide();
	
func on_floor() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2.DOWN * 16)
	query.exclude = [self]
	var res = space_state.intersect_ray(query)
	
	return not res.is_empty()

func pass_input(_dir: float, _primary: bool, _secondary: bool):
	curr_dir = _dir
	
	if (_primary and _primary != primary):
		on_primary_action()
	primary = _primary
	if (_secondary and _secondary != secondary):
		on_primary_action()
	#Maybe add primary/secondary end?
	secondary = _secondary

func on_primary_action():
	if action_node == null:
		return
	action_node.primary_action()

func on_secondary_action():
	if action_node == null:
		return
	action_node.secondary_action()
