extends CanvasLayer

@onready var exit_btn: Button = $ExitBtn

func _ready() -> void:
	exit_btn.pressed.connect(func(): get_tree().quit())

func _on_try_again_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()
