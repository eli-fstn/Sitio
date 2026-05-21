extends Enemy
var last_direction = Vector2.DOWN
var is_attacking = false
var can_attack = true
var hitbox_offset: Vector2

@onready var final_enemy = $AnimatedSprite2D
@onready var wings_flapping = $AudioStreamPlayer2D
@onready var hitbox: Area2D = $Hitbox

@export var attack_range := 130.0
@export var attack_cooldown := 3

func _ready():
	max_health = 400
	health = max_health
	hitbox_offset = hitbox.position

func _physics_process(delta):

	if target == null:
		play_animation("walk", last_direction)
		return

	var distance = global_position.distance_to(target.global_position)

	if is_attacking:
		return

	if distance <= attack_range:
		attack()
	else:
		chase(delta)

	move_and_slide()
	
func attack():

	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	play_animation("attack", last_direction)
	update_hitbox_offset()

	await get_tree().create_timer(0.5).timeout

	hitbox.monitoring = true

	await get_tree().create_timer(0.15).timeout

	hitbox.monitoring = false

	await get_tree().create_timer(0.5).timeout

	is_attacking = false

	# COOLDOWN STARTS HERE
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func chase(_delta: float) -> void:

	var direction = global_position.direction_to(target.global_position)

	wings_flapping.pitch_scale = 0.9
	wings_flapping.volume_db = 10

	if direction != Vector2.ZERO:

		velocity = direction * speed
		last_direction = direction

		play_animation("walk", last_direction)

	else:

		velocity = Vector2.ZERO
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

func update_hitbox_offset():
	var x := hitbox_offset.x
	var y := hitbox_offset.y

	if abs(last_direction.x) > abs(last_direction.y):

		if last_direction.x > 0:
			# RIGHT
			hitbox.position = Vector2(y, -x)
			hitbox.rotation_degrees = 90
		else:
			# LEFT
			hitbox.position = Vector2(-y, x)
			hitbox.rotation_degrees = 90

	else:

		if last_direction.y > 0:
			# DOWN
			hitbox.position = Vector2(x, y)
			hitbox.rotation_degrees = 0
		else:
			# UP
			hitbox.position = Vector2(x, -y)
			hitbox.rotation_degrees = 0
