extends PanelContainer

@onready var transition = $Blur
var is_exiting = false

func resume():
	get_tree().paused = false
	transition.play_backwards("blur", -3)

func pause():
	get_tree().paused = true
	transition.play("blur")

func esc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()
		
func _ready() -> void:
	transition.play("RESET")
	
func _process(delta: float) -> void:
	esc()

func _on_resume_button_pressed() -> void:
	$VBoxContainer/Pressed.play()
	resume()

func _on_restart_button_pressed() -> void:
	$VBoxContainer/Pressed.play()
	await $VBoxContainer/Pressed.finished
	#get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:	
	$VBoxContainer/Pressed.play()
	await $VBoxContainer/Pressed.finished
	get_tree().quit()
