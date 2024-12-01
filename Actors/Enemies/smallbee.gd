extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_box_component: Area2D = $AttackBoxComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var wall_detector: RayCast2D = $WallDetector

@export var PATROL_SPEED: float = 50.0
@onready var hitbox: CollisionShape2D = $Hitbox

var PATROL_HEIGHT 


var direction: int = -1

func _ready() -> void:
	PATROL_HEIGHT = global_position.y
	#print(PATROL_HEIGHT)
	animated_sprite_2d.play("Fly")
	
func _physics_process(delta: float) -> void:
	velocity.x = PATROL_SPEED * direction
	#print(global_position.y)
	if wall_detector.is_colliding():
		update_direction()
	
	move_and_slide()

func update_direction():
	if direction == 1:
		animated_sprite_2d.flip_h = false
	else: animated_sprite_2d.flip_h = true
	direction *= -1
	wall_detector.scale.x *= -1
