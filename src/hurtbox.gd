extends Area2D

@onready var enemy = get_parent()

func take_damage(amount):
	if enemy.has_method("take_damage"):
		enemy.take_damage(amount)
