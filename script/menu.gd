extends Node2D

@onready var transition = $Transition
var is_changing_scene = false
var is_exiting = false
@onready var t = $blink_timer
var dim = false
var strong_duration = 2.0 

func _ready() -> void:
	$Transition/bg_transition.show()
	transition.play("fade_in")
	await transition.animation_finished
	$Transition/bg_transition.hide()
	$Backsound.play()
	t.start()
	dim = true

func _process(ft: float) -> void:
	if dim:
		$PointLight2D.energy -= 0.1
		if $PointLight2D.energy < 1.0:
			$PointLight2D.energy = 1.0  # Prevent energy from going negative
	else:
		$PointLight2D.energy = 50

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

func _on_blink_timer_timeout() -> void:
	if dim:
		# Light is currently dimming, set it to strong and start the strong duration timer
		dim = false
		t.set_wait_time(strong_duration)
	else:
		# Light is currently strong, set it to dim and start the random cooldown timer
		dim = true
		t.set_wait_time(randf_range(2.0, 5.0))
	t.start()
