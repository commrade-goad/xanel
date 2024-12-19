extends Node2D

@onready var transition = $Transition
var is_changing_scene = false

func _ready() -> void:
	transition.play("fade_in")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out" and is_changing_scene:  # Hanya ganti scene jika fade_out selesai
		get_tree().change_scene_to_file("res://scene/main.tscn")
	elif anim_name == "fade_in":
		$Transition/bg_transition.hide()
		transition.stop()

func _on_button_play_pressed() -> void:
	if not is_changing_scene:
		$Transition/bg_transition.show()
		transition.play("fade_out")
		is_changing_scene = true
