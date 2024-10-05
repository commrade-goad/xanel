extends Node2D

signal hit
signal hide_sword
signal show_sword
signal rotate_sword(flip:bool)
@export var roll_speed = 2000
@export var speed = 250
@export var friction = 0.2 
@export var hp = 100
@export var sp = 100
var screen_size
var velocity = Vector2.ZERO
var rolling = false
var attacking = false


func _ready() -> void:
    screen_size = get_viewport_rect().size
    position.x = 0
    position.y = 0
    $player_sprite.play()

func _process(delta: float) -> void:

    if rolling == true:
        if $player_sprite.animation != "roll":
            $player_sprite.animation = "roll"
    elif velocity.length() > 1 and rolling == false:
        if $player_sprite.animation != "walk":
            $player_sprite.animation = "walk"
    else:
        if $player_sprite.animation != "idle":
            $player_sprite.animation = "idle"

    var input_velocity = Vector2.ZERO
    if Input.is_action_pressed("p_right"):
        input_velocity.x += 1
    if Input.is_action_pressed("p_left"):
        input_velocity.x -= 1
    if Input.is_action_pressed("p_up"):
        input_velocity.y -= 1
    if Input.is_action_pressed("p_down"):
        input_velocity.y += 1

    if input_velocity.length() > 0:
        input_velocity = input_velocity.normalized() * speed


    if Input.is_action_just_pressed("p_roll") and rolling == false:
        if Input.is_action_pressed("p_right"):
            input_velocity.x += roll_speed
            rolling = true
        if Input.is_action_pressed("p_left"):
            input_velocity.x -= roll_speed
            rolling = true
        if Input.is_action_pressed("p_up"):
            input_velocity.y -= roll_speed
            rolling = true
        if Input.is_action_pressed("p_down"):
            input_velocity.y += roll_speed
            rolling = true
        if rolling == true:
            $player_hand.hide()
            emit_signal("hide_sword")
            $player_hand_main.hide()
            $roll_timer.start()

    velocity = velocity.lerp(input_velocity, friction)

    position += velocity * delta

    if velocity.x != 0:
        $player_sprite.flip_h = velocity.x < 0

    var mouse_pos = get_global_mouse_position()

    var player_global_pos = $player_sprite.global_position
    var angle = atan2(mouse_pos.y - player_global_pos.y, mouse_pos.x - player_global_pos.x)
    if rolling == false:
        $player_sprite.flip_h = angle >= 1.5 or angle <= -1.5
    
    # sword
    var offset = Vector2(cos(angle), sin(angle)) * 18
    $p_sword.global_position = Vector2(player_global_pos.x - 5, player_global_pos.y + 2) + offset
    emit_signal("rotate_sword", angle >= 1.5 or angle <= -1.5)
    if angle >= 1.5 or angle <= -1.5 :
        $p_sword.global_position.x += 10
    $p_sword.rotation = angle + PI / 2
    
    # hand
    var hand_offset = Vector2(cos(angle) - 5, sin(angle))
    if angle >= 1.5 or angle <= -1.5 :
        hand_offset = Vector2(cos(angle) + 5, sin(angle))
    $player_hand_main.flip_v = angle >= 1.5 or angle <= -1.5
    $player_hand_main.rotation = angle
    $player_hand_main.global_position = player_global_pos + hand_offset
    $player_hand.flip_v = angle >= 1.5 or angle <= -1.5
    $player_hand.rotation = angle + PI / 18
    $player_hand.global_position = Vector2(player_global_pos.x, player_global_pos.y) + hand_offset
    if (angle <= -0.8 and angle >= -1.5) or (angle <= 2.0 and angle >= 1.5):
        $player_hand.hide()
    elif rolling == false:
        $player_hand.show()


func _on_roll_timer_timeout() -> void:
    if rolling == true:
        $player_sprite.animation = "idle"
        rolling = false
        $player_hand_main.show()
        $player_hand.show()
        emit_signal("show_sword")
        velocity = Vector2.ZERO
    $roll_timer.stop()
