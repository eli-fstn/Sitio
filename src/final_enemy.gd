extends CharacterBody2D

const speed: float = 200
var target = null
var last_direction = Vector2.DOWN

@onready var final_enemy = $AnimatedSprite2D
@onready var wings_flapping = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if target:
		_attack(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _attack(_delta: float) -> void:
	var direction = global_position.direction_to(target.global_position)
	wings_flapping.pitch_scale = 0.9
	wings_flapping.volume_db = 10

	if direction != Vector2.ZERO:
		velocity = direction * speed
		last_direction = direction
		play_animation("walk", last_direction)
	else:
		velocity = Vector2.ZERO
		play_animation("idle", last_direction)
	
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
