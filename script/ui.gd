extends Node2D
var time = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_timer_timeout() -> void:
    time += 1
    
    # Format the time as "MM : SS"
    var minutes = str(time / 60)
    var seconds = str(time % 60)
    # Pad with leading zeros if needed
    if minutes.length() < 2:
        minutes = "0" + minutes
    if seconds.length() < 2:
        seconds = "0" + seconds
    
    # Update the text label
    $time.text = "[center] %s : %s [/center]" % [minutes, seconds]
    $Timer.start()

func _on_node_pause_timer() -> void:
    $Timer.stop()

func _on_node_resume_timer() -> void:
    $Timer.start()
