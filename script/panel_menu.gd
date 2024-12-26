extends PanelContainer

@onready var transition = $Blur

var is_exiting = false
var is_paused = false

func resume():
	get_tree().paused = false
	is_paused = false
	transition.play_backwards("blur")

func pause():
	get_tree().paused = true
	is_paused = true
	transition.play("blur")

func esc():
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			resume()
		else:
			pause()

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
	#get_tree().reload_current_scene() ini buat restart tp rusak

func _on_exit_button_pressed() -> void:	
	$VBoxContainer/Pressed.play()
	await $VBoxContainer/Pressed.finished
	get_tree().quit()
