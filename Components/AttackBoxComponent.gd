extends Area2D

signal chase_began(new_direction)
signal chase_ended



func _on_body_entered(body):
	if is_player(body):
		var direction = Vector2(body.global_position - self.global_position)
		direction /= direction.length()
		#print(direction)
		chase_began.emit( direction)


func _on_body_exited(body):
	if is_player(body):
		chase_ended.emit()

func is_player(node) -> bool:
	return node is Player
