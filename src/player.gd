extends CharacterBody2D

const speed = 1000
var last_direction: Vector2 = Vector2.DOWN
var hitbox_offset: Vector2

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta) -> void:
	process_movement()
	process_animation()
	move_and_slide()

func process_movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		last_direction = direction
	else:
		velocity = Vector2.ZERO
	
func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("walk", last_direction)
	else:
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
			
