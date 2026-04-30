extends Area2D

@onready var dog_sound = $AudioStreamPlayer2D
var has_entered = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_entered:
		has_entered = true
		dog_sound.play(12.0)
