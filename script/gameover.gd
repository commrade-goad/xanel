extends Node2D
var label: RichTextLabel
var color: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    label = $CenterContainer/RichTextLabel
    color = $ColorRect
    $Timer.start()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_timer_timeout() -> void:
    var col = color.color
    if col.a < 0.7:
        color.color = Color(0, 0, 0, col.a + 0.05)
        $Timer.start()
