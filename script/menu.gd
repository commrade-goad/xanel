extends Node2D

@onready var transition = $Transition
var is_changing_scene = false
var is_exiting = false

func _ready() -> void:
	$Transition/bg_transition.show()
	transition.play("fade_in")
	await transition.animation_finished
	$Transition/bg_transition.hide()
	$Backsound.play()
	
# Button Play func
func _on_button_play_pressed() -> void:
	if not is_changing_scene and not is_exiting:
		$Pressed.play()
		$Transition/bg_transition.show()
		transition.play("fade_out")
		is_changing_scene = true # change bool after pressed play button
		
func _on_settings_pressed() -> void:
	$Pressed.play()
	$Menu.hide()
	$Video.show()

func _on_back_from_video_pressed() -> void:
	$Pressed.play()
	$Menu.show()
	$Video.hide()

# Button Exit func
func _on_exit_button_down() -> void:
	if not is_exiting and not is_changing_scene:
		$Pressed.play()
		$Transition/bg_transition.show()
		transition.play("fade_out")
		is_exiting = true # change bool after pressed exit button
		
# Handling the Transition
func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if is_changing_scene:
			get_tree().change_scene_to_file("res://scene/main.tscn")
		elif is_exiting:
			get_tree().quit()
