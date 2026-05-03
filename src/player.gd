extends CharacterBody2D

const speed = 400
var last_direction: Vector2 = Vector2.DOWN
var hitbox_offset: Vector2

@onready var sprite = $AnimatedSprite2D
@onready var footsteps = $AudioStreamPlayer2D
@onready var hitbox: Area2D = $Hitbox

var is_attacking = false

func _physics_process(_delta) -> void:
	if not is_attacking:
		process_movement()
		process_animation()
	else:
		velocity = Vector2.ZERO
	
	handle_attack()
	move_and_slide()
	
func handle_attack() -> void:
	if is_attacking:
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()
		
func start_attack() -> void:
	is_attacking = true
	play_animation("attack", last_direction)
	enable_hitbox()
	
func enable_hitbox() -> void:
	hitbox.monitoring = true
	
	if abs(last_direction.x) >= abs(last_direction.y):
		if last_direction.x > 0:
			hitbox.position = Vector2(20, 0)
		else:
			hitbox.position = Vector2(-20, 0)
	else:
		if last_direction.y > 0:
			hitbox.position = Vector2(0, 20)
		else:
			hitbox.position = Vector2(0, -20)

func process_movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		last_direction = direction
	else:
		velocity = Vector2.ZERO
	
func process_animation() -> void:
	if velocity != Vector2.ZERO:
		if not footsteps.playing:
			footsteps.play()
		play_animation("walk", last_direction)
	else:
		if footsteps.playing:
			footsteps.stop()
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if abs(dir.x) >= abs(dir.y):
		sprite.flip_h = dir.x > 0
		sprite.play(prefix + "_left")
	else:
		if dir.y > 0:
			sprite.play(prefix + "_front")
		else:
			sprite.play(prefix + "_back")
			

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.begins_with("attack"):
		is_attacking = false
		hitbox.monitoring = false
		play_animation("idle", last_direction)
