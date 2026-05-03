extends Area2D

@export var damage := 10

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(damage, global_position)
