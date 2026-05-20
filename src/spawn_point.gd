extends Marker2D

@export var enemy_scene: PackedScene

@onready var enemy_container = $"../Enemies"
@onready var spawn_points = $"../SpawnPoints/"

func spawn_wave(amount: int):
	for i in amount:
		spawn_enemy()
		
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var point = spawn_points.pick_random()
	enemy.global_position = point.global_position
	enemy_container.add_child(enemy)
