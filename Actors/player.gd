extends CharacterBody2D
class_name Player

signal game_over

@export var jump_impulse: float = 200.0
var jump_impulse2: float = 250.0
var move_speed: float = 100.0
var gravity: float = 400.0
@onready var animated_sprite_2d = $AnimatedSprite2D

var scene_tree = get_tree()
const MAX_HEALTH = 5
var player_health: int = 3
var damage_taken: bool = false
var start_position: Vector2

var jump_count = 0
var max_jump = 2

@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
var is_dashing: bool = false
var dash_timer: float = 0.0
var can_dash = true
func _ready():
	start_position = global_position
	print(start_position)

	
	
func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	
	#JUMP
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play(
			"fall" if velocity.y > 0 else "jump"
			)
	else:
		jump_count = 0
		animated_sprite_2d.play("run" if direction else "idle")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_count += 1
		velocity.y -= jump_impulse #fix this shit
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_impulse2
	if Input.is_action_just_released("jump") and !is_on_floor() and jump_count == max_jump and velocity.y == 0:
		velocity.y = gravity * delta
	
	
	#DASH
	if Input.is_action_just_pressed("dash") and can_dash:
		animated_sprite_2d.play("dash")
		is_dashing = true
		$DashTimer.start()
		#$DashCoolDown.start()
	if direction:
		if is_dashing:
			velocity.x = direction * dash_speed
		else:
			velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	update_facing_direction()
	move_and_slide()

func update_facing_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true

func take_damage(amount, body) -> void:
	if not damage_taken:
		if body.global_position.y < get_node("HurtBoxComponent").global_position.y:
			return
		set_physics_process(false)
		animated_sprite_2d.play("hurt")
		var old_health = player_health
		player_health -= amount
		damage_taken = not damage_taken
		Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)
		if player_health > 0:
			$ReviveTimer.start()
		#else:
			#scene_tree.reload_current_scene()
#			

func extra_live(value) -> void:
	var old_health = player_health
	player_health += value
	Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)

func _on_revive_timer_timeout():
	global_position = start_position
	animated_sprite_2d.play("idle")
	damage_taken = false
	set_physics_process(true)


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _on_dash_cool_down_timeout() -> void:
	can_dash = false
