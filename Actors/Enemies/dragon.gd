extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D


func _on_ready() -> void:
	animated_sprite_2d.play("idle")



func breath() -> void:
	animated_sprite_2d.play("breath") 


func _on_area_2d_body_entered(body: Node2D) -> void:
	breath()
	
