extends Control

@onready var window_option = $HBox_Video/Window_Option

const WINDOW_MODE_ARRAY :Array[String] = [
	"FULL-SCREEN",
	"WINDOW MODE",
	"BORDERLESS WINDOW",
	"BORDERLESS FULL-SCREEN"
]

func add_window_mode():
	for i in WINDOW_MODE_ARRAY:
		window_option.add_item(i)
		
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Full-Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			
func _ready() -> void:
	add_window_mode()
	window_option.item_selected.connect(on_window_mode_selected)
