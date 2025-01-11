extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.beans += 1
		Events.bean_collected.emit()
		queue_free()
