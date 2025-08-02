extends Camera2D

#@export var move_speed := 10.0
@export var zoom_scale := 12.0
@export var edge_buffer := 10.0
@export var max_zoom := 5.0
@export var min_zoom := 2.0
@export var targets : Array

var current_zoom := 5.0

func _ready():
	targets = get_tree().get_nodes_in_group("Players")

func _process(delta):
	var targetPosition = Vector2(0, 0)
	
	for t in targets:
		targetPosition += t.global_position
	
	targetPosition /= 3
	
	global_position = targetPosition
	
	var spread_dl = Vector2(99999, 99999)
	var spread_ur = Vector2(-99999, -99999)
	
	for t in targets:
		if t.global_position.y < spread_dl.y:
			spread_dl.y = t.global_position.y
		if t.global_position.y > spread_ur.y:
			spread_ur.y = t.global_position.y
		if t.global_position.x < spread_dl.x:
			spread_dl.x = t.global_position.x
		if t.global_position.x > spread_ur.x:
			spread_ur.x = t.global_position.x
	
	var spread = spread_ur - spread_dl
	
	spread.x /= 16
	spread.y /= 9
	
	var zl = min(max_zoom, max(min_zoom, 1/max(spread.x, spread.y) * zoom_scale))
	zoom = Vector2(zl, zl)
