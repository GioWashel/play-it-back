extends Node2D
class_name Drummer_Rift

@export var rift_speed := 32.0
@export var breaking_distance := 16.0
@export var slide_height := 17.0
@export var jump_strength := 128.0
var hit = []
var dir : Vector2
var init_time : float

func init(_dir: Vector2):
	dir = _dir.normalized()
	init_time = Time.get_unix_time_from_system()

func _process(delta):	
	global_position += dir * rift_speed * delta
	
	var space_state = get_world_2d().direct_space_state
	#Update height
	var sp = self.global_position + slide_height * Vector2.UP
	var rquery = PhysicsRayQueryParameters2D.create(sp, sp + Vector2.DOWN * slide_height*2)
	rquery.exclude = [self]
	var rres = space_state.intersect_ray(rquery)

	if rres:
		global_position = Vector2(global_position.x, rres.get("position").y)
	
	var start_pos = self.global_position + 10 * Vector2.UP
	var query = PhysicsRayQueryParameters2D.create(start_pos, start_pos + dir * breaking_distance)
	query.exclude = [self]
	var res = space_state.intersect_ray(query)
	
	if res.get("collider"):
		if ("environment" in res.get("collider").get_groups()):
			begin_end()

func begin_end():
	$Sprite.play("Wind Down")
	#Make not hit

func _on_sprite_animation_finished():
	if $Sprite.animation == "Wind Down":
		queue_free()

func _on_body_entered(body):
	if ("Players" not in body.get_groups() or body in hit):
		return
	hit.append(body)
	
	body.velocity.y = -jump_strength
