class_name Checkpoint extends Node2D


signal checkpoint_activated(pos: Vector2)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimatedSprite2D.play(&"active")
		checkpoint_activated.emit(global_position)
