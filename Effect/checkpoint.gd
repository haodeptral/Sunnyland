extends Area2D

var checkpoint_pos

func _ready() -> void:
	checkpoint_pos = $RespawnPoint.global_position
	print(checkpoint_pos)



func _on_body_entered(body: Node2D) -> void:
	body.checkpoint = checkpoint_pos
