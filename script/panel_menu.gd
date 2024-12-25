extends PanelContainer
@onready var transition = $Blur

func _ready() -> void:
	transition.play_backwards("RESET")

func resume():
	get_tree().paused = false
	transition.play_backwards("blur")

func pause():
	get_tree().paused = true
	transition.play("blur")

func esc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == false:
		resume()

func _on_resume_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
func _process(delta: float) -> void:
	esc()
