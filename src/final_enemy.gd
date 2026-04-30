extends CharacterBody2D

const speed: float = 50
var target = null
var last_direction = Vector2.DOWN

@onready var final_enemy = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if target:
		_attack(delta)

func _attack(delta: float) -> void:
	var direction = position.direction_to(target.position)
	position += direction * speed * delta

	if direction != Vector2.ZERO:
		last_direction = direction
		play_animation("walk", last_direction)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target = null
		play_animation("walk", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		final_enemy.flip_h = dir.x > 0
		final_enemy.play(prefix + "_left")
	else:
		if dir.y > 0:
			final_enemy.play(prefix + "_front")
		else:
			final_enemy.play(prefix + "_back")
