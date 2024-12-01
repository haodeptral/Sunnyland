extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_box_component: Area2D = $AttackBoxComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var hit_box: HitBox = $HitBoxComponent


@export var ATTACK_SPEED: float = 200.0
@export var PATROL_SPEED: float = 50.0
@onready var hitbox: CollisionShape2D = $Hitbox

var PATROL_HEIGHT 


var direction: int = -1
func _physics_process(delta: float) -> void:
	velocity.x = PATROL_SPEED * direction
	#print(global_position.y)
	if wall_detector.is_colliding():
		update_direction()
	if ground_detector.is_colliding():
		back_to_idle()
	if (global_position.y < PATROL_HEIGHT):
		global_position.y += PATROL_SPEED * delta
		#print(global_position.y)
	
	move_and_slide()

func _ready() -> void:
	PATROL_HEIGHT = global_position.y
	#print(PATROL_HEIGHT)
	animated_sprite_2d.play("idle")

func update_direction():
		if direction == 1:
			animated_sprite_2d.flip_h = false
		else: animated_sprite_2d.flip_h = true
		direction *= -1
		wall_detector.scale.x *= -1
		ground_detector.scale.x *= -1
		attack_box_component.scale.x *= -1
		#print(direction)

func back_to_idle():
	animated_sprite_2d.play("idle")
	velocity.y = PATROL_SPEED * -1
	

func _on_chase_began(new_direction: Variant) -> void:
	#print("body entered")
	animated_sprite_2d.play("attack")
	velocity = ATTACK_SPEED * new_direction
	pass # Replace with function body.



func _on_chase_ended() -> void:
	
	pass # Replace with function body.
func take_damage(_amount, body) -> void:
	if body.global_position.y > get_node("HurtBoxComponent").global_position.y:
		return
	animated_sprite_2d.play("hurt")
	#$Timer.start()
	die()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hit")
	body.death = true
	pass # Replace with function body.
