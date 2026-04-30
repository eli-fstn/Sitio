extends Node2D

@onready var cricket_sound = $AudioStreamPlayer

func _ready() -> void:
	cricket_sound.play()
