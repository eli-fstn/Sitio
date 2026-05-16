extends CharacterBody2D

const speed = 400
var last_direction: Vector2 = Vector2.DOWN
var hitbox_offset: Vector2

@onready var sprite = $AnimatedSprite2D
@onready var footsteps = $AudioStreamPlayer2D
@export var hitbox: Area2D
@export var max_health := 3

var is_attacking = false
var health = 0

func _ready():
	health = max_health
	hitbox_offset = hitbox.position
	
func take_damage(amount):
	health -= amount
	print("Player HP: ", health)
	if health <= 0:
		die()
		
func die():
	print("Player died")
	queue_free()

func _physics_process(_delta) -> void:
	hitbox.monitoring = false
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
		
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()
	
func attack():
	is_attacking = true
	hitbox.monitoring = true
	print("attack")
	play_animation("attack", last_direction)

func process_movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
	
func process_animation() -> void:
	if is_attacking:
		return
		
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
	if is_attacking:
		is_attacking = false
	
func update_hitbox_offset():
	var x := hitbox_offset.x
	var y := hitbox_offset.y
	
	match last_direction:
		Vector2.UP:
			hitbox.position = Vector2(x, -y)
			hitbox.rotation_degrees = 0
		Vector2.DOWN:
			hitbox.position = Vector2(x, y)
			hitbox.rotation_degrees = 0
		Vector2.RIGHT:
			hitbox.position = Vector2(y, -x)
			hitbox.rotation_degrees = 90
		Vector2.LEFT:
			hitbox.position = Vector2(-y, x)
			hitbox.rotation_degrees = 90

func _on_hitbox_area_entered(area: Area2D) -> void:
	if is_attacking:
		print("Hit")
