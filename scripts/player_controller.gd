extends CharacterBody2D
class_name Player_Controller

var curr_dir : float
var primary : bool
var secondary: bool

const SPEED = 100
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 0.8
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
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
		

func pass_input(_dir: float, _primary: bool, _secondary: bool):
	curr_dir = _dir
	primary = _primary
	secondary = _secondary
