extends Node2D

var rift := preload("res://scenes/drummer_rift.tscn")

@export var cooldownTimer : Timer
@export var ray_length = 32
@export var side_offsets = 16

var last_action := 0

func primary_action():
	if not cooldownTimer.is_stopped():
		return
	
	cooldownTimer.start()
	
	create_rift(self.global_position + Vector2.RIGHT * side_offsets).init(Vector2.RIGHT)
	create_rift(self.global_position + Vector2.LEFT * side_offsets).init(Vector2.LEFT)

func create_rift(start_pos : Vector2) -> Drummer_Rift:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, start_pos + Vector2.DOWN * ray_length)
	query.exclude = [self]
	var res = space_state.intersect_ray(query)
	
	var r := rift.instantiate()
	r.global_position = res.position
	get_tree().get_root().get_child(0).add_child(r)
	return r


func secondary_action():
	pass
