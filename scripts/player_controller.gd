extends CharacterBody2D
var is_active := false

const SPEED = 100
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 0.8
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# player selected	
	if is_active:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			$Sprite2D.flip_h = (velocity.x < 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	var previous_velocity = velocity; 
	move_and_slide();
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		_handle_collision(collision, previous_velocity)
		
func _handle_collision(collision: KinematicCollision2D, old_velocity: Vector2):
	velocity *= AIR_RESISTANCE
	var collider = collision.get_collider();
	# if we collide with another player
	if collider is CharacterBody2D && collider != self:
		var normal = collision.get_normal();
		if is_on_floor():
			velocity.x += normal.x * 15
			velocity.y += normal.y * -10;
		if collider.has_method("recieve_push"):
			collider.call("recieve_push", Vector2(-normal.x * 15, -10))
func recieve_push(push_velocity: Vector2):
	velocity += push_velocity;
