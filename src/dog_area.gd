extends Area2D

@onready var dog_sound = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dog_sound.play(12.0)
		$CollisionShape2D.set_deferred("disabled", true)