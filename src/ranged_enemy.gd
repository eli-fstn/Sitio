extends Enemy

@export var projectile: PackedScene

var can_attack := true
var attack_range := 200.0

func _physics_process(delta):
	if target:
		var dist = global_position.distance_to(target.global_position)
		if dist <= attack_range:
			velocity = Vector2.ZERO
			if can_attack:
				can_attack = false
				shoot()
				$AttackCooldown.start()
		else:
			chase_target()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func shoot():
	if !target:
		return

	var projectile = projectile.instantiate()
	projectile.global_position = $ShootPoint.global_position
	projectile.direction = global_position.direction_to(target.global_position)
	get_tree().current_scene.add_child(projectile)


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
