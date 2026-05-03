extends CharacterBody2D

enum Facing { UP, DOWN, LEFT, RIGHT }
var facing = Facing.DOWN

const speed = 400
#var hitbox_offset: Vector2

@onready var sprite = $AnimatedSprite2D
@onready var footsteps = $AudioStreamPlayer2D
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_pivot: Node2D = $AttackPivot
@export var hitbox_shape: CollisionShape2D

var shape: RectangleShape2D:
	get: return hitbox_shape.shape

var is_attacking = false

func _ready():
	hurtbox.damaged.connect(_on_damaged)
	
func _physics_process(_delta) -> void:
	if not is_attacking:
		process_movement()
		process_animation()
	else:
		velocity = Vector2.ZERO
	
	handle_attack()
	move_and_slide()

# ===================== MOVEMENT ==================
func process_movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		
		if abs(direction.x) > abs(direction.y):
			facing = Facing.RIGHT if direction.x > 0 else Facing.LEFT
		else:
			facing = Facing.DOWN if direction.y > 0 else Facing.UP
	else:
		velocity = Vector2.ZERO
		
# ===================== ATTACK INPUT ==================
func handle_attack() -> void:
	if is_attacking:
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()
		
func start_attack() -> void:
	is_attacking = true
	update_attack_pivot()
	update_hitbox_orientation()
	play_attack_animation()
	enable_hitbox()
	
func end_attack():
	is_attacking = false
	hitbox.monitoring = false
	play_animation("idle")
	
func update_attack_pivot() -> void:
	match facing:
		Facing.UP:
			attack_pivot.position = Vector2(0, -10)
		Facing.DOWN:
			attack_pivot.position = Vector2(0, 10)
		Facing.LEFT:
			attack_pivot.position = Vector2(-10, 0)
		Facing.RIGHT:
			attack_pivot.position = Vector2(10, 0)

# ===================== HITBOX CONTROL ==================
func enable_hitbox() -> void:
	hitbox.monitoring = true
	hitbox.global_position = $AttackPivot.global_position
	
func update_hitbox_orientation() -> void:
	if shape == null:
		return
		
	match facing:
		Facing.LEFT, Facing.RIGHT:
			# vertical hitbox (tall)
			shape.extents = Vector2(6, 12)
			hitbox.rotation_degrees = 0

		Facing.UP, Facing.DOWN:
			# horizontal hitbox (wide)
			shape.extents = Vector2(12, 6)
			hitbox.rotation_degrees = 0

# ===================== ANIMATION ==================
func process_animation() -> void:
	if velocity != Vector2.ZERO:
		if not footsteps.playing:
			footsteps.play()
		play_animation("walk")
	else:
		if footsteps.playing:
			footsteps.stop()
		play_animation("idle")
		
func play_animation(prefix: String) -> void:
	match facing:
		Facing.LEFT:
			sprite.flip_h = false
			sprite.play(prefix + "_left")
			
		Facing.RIGHT:
			sprite.flip_h = true
			sprite.play(prefix + "_left")
			
		Facing.DOWN:
			sprite.play(prefix + "_front")
			
		Facing.UP:
			sprite.play(prefix + "_back")
			
func play_attack_animation() -> void:
	match facing:
		Facing.LEFT:
			sprite.flip_h = false
			sprite.play("attack_left")

		Facing.RIGHT:
			sprite.flip_h = true
			sprite.play("attack_left")

		Facing.DOWN:
			sprite.play("attack_front")

		Facing.UP:
			sprite.play("attack_back")

# ===================== ANIMATION FINISHED ==================
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.begins_with("attack"):
		end_attack()

# ===================== DAMAGE RESPONSE ==================
func _on_damaged(amount: int):
	print("took damage:", amount)
	
	# simple feedback
	sprite.modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
