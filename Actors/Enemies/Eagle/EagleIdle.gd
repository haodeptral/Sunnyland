extends State
class_name EagleIdle



@export var PATROLL = 50
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
#@export var ATTACK = 300
@onready var wall_detector: RayCast2D = $WallDetector
@export var enemy : CharacterBody2D
var direction
@onready var ground_detector: RayCast2D = $GroundDetector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("idle")

func Enter():
	direction = 1

func Update(delta: float):
	if wall_detector.collide_with_areas:
		direction *= -1
		wall_detector.scale.x *= -1
		ground_detector.scale.x *= -1
		
	pass
func Physic_Update(delta: float):
	enemy.velocity.x = PATROLL * direction
	pass
