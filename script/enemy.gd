extends Node2D

signal free_mem(idx: int)
@export var speed = 270
@export var friction = 0.2
@export var hp = 100
var velocity = Vector2.ZERO
var enemies: Array
var player: Area2D 
var active: String
var plen
var offset
var attack_sprite: AnimatedSprite2D
var attack_coll: CollisionShape2D
var attack_cooldown: Timer
var enemy_sprite: AnimatedSprite2D
var arm_sprite: Sprite2D
var blood_sprite
var can_attack = false
var lock_angle = false
var p
var s
var die = false
var idx_to_del = -1

func _ready() -> void:
    active = "enemy_a" 
    attack_sprite = get_node(active + "/slash_a/slash_sprite")
    attack_coll = get_node(active + "/slash_a/slash_coll")
    attack_cooldown = get_node(active + "/slash_a/slash_cooldown")
    arm_sprite = get_node(active + "/arm")
    enemy_sprite = get_node(active + "/sprite")
    attack_sprite.play()
    player = get_parent().get_node("player")
    p = get_parent().get_node("player")
    s = p.get_node("p_sword")
    enemy_sprite.animation = "default"
    enemy_sprite.play()
    blood_sprite = get_node(active + "/blood")
    blood_sprite.hide()

func _process(delta: float) -> void:
    
    if hp <= 0:
        var idx = 0
        for other_enemy in enemies:
            if other_enemy == self:
                enemy_sprite.animation = "die"
                idx_to_del = idx
                die = true
                attack_sprite.frame = 0
                attack_sprite.stop()
            idx += 1
    
    attack_sprite.global_position = position
    attack_sprite.z_index = 101
    if player:
        # movement
        var diff = player.position - position
        plen = diff.length()
        var sprite = get_node(active + "/sprite")
        sprite.flip_h = diff.x < 0
        
        separate_from_others(delta)

        if plen <= 50 and can_attack == true:
            attack_sprite.play()
            attack_cooldown.start()

        var distance = 50
        if can_attack == false:
            distance += 100
        if plen > distance :
            var direction = diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, 0.2)
            if lock_angle == false:
                position += velocity * delta
        elif can_attack == false and plen < distance - 50:
            var direction = -diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, 0.2)
            if lock_angle == false:
                position += velocity * delta

        # attack
        if lock_angle == false:
            var angle = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
            offset = Vector2(cos(angle), sin(angle)) * 30
            attack_sprite.rotation = angle

        if diff.x < 0 :
            attack_sprite.global_position += offset
            attack_sprite.flip_v = true
        else:
            attack_sprite.global_position += offset
            attack_sprite.flip_v = false

        attack_coll.global_position = attack_sprite.global_position
        attack_coll.rotation = attack_sprite.rotation
        arm_sprite.global_position = attack_sprite.global_position - offset

        arm_sprite.rotation = attack_sprite.rotation

        if attack_sprite.frame == 1:
            lock_angle = true

        if attack_sprite.frame <= 3 or attack_sprite.frame >= 8:
            attack_coll.disabled = true
        else:
            attack_coll.disabled = false

        if attack_sprite.frame == 10:
            can_attack = false
            lock_angle = false
            attack_cooldown.start()
            attack_sprite.stop()

# Function to receive the array of enemies
func set_enemies(enemy_array: Array) -> void:
    enemies = enemy_array

func separate_from_others(delta: float) -> void:
    var separation_force = Vector2.ZERO
    var separation_radius = 750  # Minimum distance to keep between enemies
    var separation_strength = 10.0  # Amplify this to make enemies repel more strongly

    for other_enemy in enemies:
        if other_enemy != self:
            var diff = position - other_enemy.position
            var distance = diff.length()

            if distance < separation_radius and distance > 0:
                var force = diff.normalized() / distance * speed
                separation_force += force * separation_strength

    velocity += separation_force * delta


func _on_slash_cooldown_timeout():
    can_attack = true


func _on_enemy_a_area_entered(area: Area2D) -> void:
    if area.name == "p_sword":
        hp -= p.attack + s.bonus_damage
        print("enemy healt: " + str(hp))
        blood_sprite.show()
        blood_sprite.play()
    pass # Replace with function body.


func _on_sprite_animation_looped() -> void:
    if die == true:
        emit_signal("free_mem", idx_to_del)


func _on_blood_animation_looped() -> void:
    blood_sprite.hide()
    blood_sprite.stop()
    blood_sprite.frame = 0
