extends Area2D

@export var spawn_points: Array[Marker2D]
@export var enemy_count := 3
@export var enemy_scene: PackedScene
@export var enemy_container: Node

var activated := false

func _on_body_entered(body):
	if activated:
		return

	if body.is_in_group("player"):
		print("Player entered")
		activated = true
		call_deferred("spawn_enemies")

func spawn_enemies():
	for i in range(enemy_count):
		var enemy_instance = enemy_scene.instantiate()
		var point = spawn_points.pick_random()
		var offset = Vector2(
			randf_range(-50, 50),
			randf_range(-50, 50)
		)

		enemy_instance.global_position = point.global_position + offset
		
		# To match the world scale. (Why you do this?)
		enemy_instance.scale = Vector2(4, 4)

		enemy_container.add_child(enemy_instance)
