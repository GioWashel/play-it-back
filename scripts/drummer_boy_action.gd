extends Node2D

var rift := preload("res://scenes/drummer_rift.tscn")
func primary_action():
	var obj := rift.instantiate()
	obj.global_position = self.global_position
	get_tree().get_root().get_child(0).add_child(obj)

func secondary_action():
	pass
