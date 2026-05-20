extends CharacterBody2D
class_name Enemy

@onready var health_bar: Node2D = $"health_bar"
@export var max_health := 100
@export var speed := 100.0

var health := 0
var target = null

func _ready():
	health = max_health;

func _physics_process(delta: float) -> void:
	chase_target()
	move_and_slide()

func take_damage(amount):
	health -= amount
	health_bar.update_health(health)
	
	print("Enemy HP: ", health)

	if health <= 0:
		die()

func die():
	queue_free()

func chase_target():
	if target:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player detected")
		target = body
