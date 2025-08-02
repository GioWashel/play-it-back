extends Node2D

@export var boom_force := 300
@export var rays := 10
@export var max_distance :=  48.0
@export var curve : Curve
@export var length := 0.5
var start : float

var db : Node2D
func _ready():
	db = get_tree().get_first_node_in_group("drummerBoy")
	global_position = db.global_position
	var angle_step = (2 * PI) / rays
	
	var space_state = get_world_2d().direct_space_state
	var poly = Polygon2D.new()
	var line = Line2D.new()
	var points : PackedVector2Array = []
	for i in range(rays):
		var current_angle = i * angle_step
		var pos = Vector2(max_distance * cos(current_angle), max_distance * sin(current_angle))
		
		points.append(pos)
		line.add_point(pos)
	
	line.add_point(line.points[0])
	line.width = 4
	line.default_color = Color(255, 255, 255, 0.4)
	poly.set_polygon(points)
	poly.color = Color(255, 255, 255, 0.1)
	add_child(poly)
	add_child(line)
	
	start = Time.get_unix_time_from_system()

func _process(delta):
	var elapsedTime = Time.get_unix_time_from_system() - start
	var precent = max(0, min(1.0, elapsedTime / length))
	
	modulate.a = curve.sample(precent)
	
	if precent == 1.0:
		queue_free()


func _on_body_entered(body):
	if "Players" not in body.get_groups():
		return
	if "drummerBoy" in body.get_groups():
		return
	
	var dir = (body.global_position - global_position).normalized()
	body.global_position += 5 * Vector2.UP
	body.velocity += dir * boom_force + 16 * Vector2.UP
	print(body.velocity)
