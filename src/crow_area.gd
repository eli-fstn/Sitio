extends Area2D

@onready var crow_sound = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		crow_sound.play()
		$CollisionShape2D.set_deferred("disabled", true)