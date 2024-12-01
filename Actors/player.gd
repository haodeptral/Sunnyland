extends CharacterBody2D
class_name Player

signal game_over
@onready var wall_detecter: RayCast2D = $WallDetecter

@export var jump_impulse: float = 200.0

@export var move_speed: float = 120.0
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

	
func gravity_force(delta):
	if wall_collider():
		#print("colided")
		velocity.y = 0
		velocity.y = 20
		print(velocity.y)
		animated_sprite_2d.play("wall_hug")
	else :
		velocity.y += gravity * delta
		
func _physics_process(delta):
	var input = Input.get_axis("move_left","move_right")
	if input > 0:
		if is_dashing:
			velocity.x = dash_speed
		else:
			velocity.x = move_speed 
		animated_sprite_2d.flip_h = false
		wall_detecter.scale.x = 1
	elif input < 0:
		if is_dashing:
			velocity.x = -dash_speed
		else:
			velocity.x = -move_speed 
		animated_sprite_2d.flip_h = true
		wall_detecter.scale.x = -1
	else: velocity.x = 0
	gravity_force(delta)
	#WALL SLIDE
	
		
		
		
	#JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
			jump_count += 1
			velocity.y -= jump_impulse
	#DOUBLE JUMP
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_count < max_jump:
			jump_count += 1
			velocity.y = 0
			velocity.y -= jump_impulse
	if not is_on_floor() and not wall_collider():
		animated_sprite_2d.play(
			"fall" if velocity.y > 0 else "jump"
			)
	else:
		if not wall_collider():
			jump_count = 0
			animated_sprite_2d.play("run" if input else "idle")
	
	#DASH
	if Input.is_action_just_pressed("dash") and can_dash:
		print("dash")
		animated_sprite_2d.play("dash")
		is_dashing = true
		can_dash = false
		$DashTimer.start()
		$DashCoolDown.start()
	
	move_and_slide()

func wall_collider():
	#print("Is coliding with wall")
	return wall_detecter.is_colliding()
	


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
	can_dash = true
