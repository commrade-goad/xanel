extends Control

signal restart

@onready var transition_fade = $Transition
@onready var transition_blur = $Blur
var is_paused = false

func resume():
	get_tree().paused = false
	is_paused = false
	transition_blur.play_backwards("blur")

func pause():
	get_tree().paused = true
	is_paused = true
	transition_blur.play("blur")

func esc():
	if Input.is_action_just_pressed("pause"):
		if is_paused == true:
			resume()
		elif is_paused == false:
			pause()

func _ready() -> void:
	$Transition/bg_transition.hide()
	transition_blur.play("RESET")
	
func _process(delta: float) -> void:
	esc()

func _on_resume_button_pressed() -> void:
	$Pressed.play()
	resume()

func _on_restart_button_pressed() -> void:
	#$Pressed.play()
	#await $Pressed.finished
	emit_signal("restart")
	get_tree().paused = false
	#transition_fade.play("fade_out")
	#await transition_fade.animation_finished
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	#$Transition/bg_transition.show()
	#$Pressed.play()
	#await $Pressed.finished
	#transition_fade.play("fade_out")
	#await transition_fade.animation_finished
	var scene_menu = "res://scene/menu.tscn"
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_menu)
	#get_tree().quit()
