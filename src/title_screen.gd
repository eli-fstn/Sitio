extends Control

@onready var start_btn: Button = $StartBtn
@onready var exit_btn: Button = $ExitBtn

func _ready() -> void:
	start_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://Scenes/main.tscn"))
	exit_btn.pressed.connect(func(): get_tree().quit())
