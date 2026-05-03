extends Area2D

signal damaged(amount)

@export var max_health := 5
var health := max_health
var invincible := false

func take_damage(amount: int, source_position: Vector2):
	if invincible:
		return

	health -= amount
	emit_signal("damaged", amount)

	start_invincibility()
	
	if health <= 0:
		die()
		

func start_invincibility():
	invincible = true
	
	await get_tree().create_timer(0.5).timeout
	invincible = false

func die():
	print("dead")
	queue_free() # or call a player death function idk
