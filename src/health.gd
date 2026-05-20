extends Node

@export var max_health: int = 100
var health: int

signal died

func _ready():
	health = max_health

func take_damage(amount: int):
	health -= amount
	print("HP:", health)

	if health <= 0:
		health = 0
		died.emit()
		die()

func die():
	get_parent().queue_free()
