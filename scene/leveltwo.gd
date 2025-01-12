extends Node2D


func _on_next_level_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.checkpoint_reached = false
		Globals.beans = 0
		Events.bean_collected.emit()
		get_tree().change_scene_to_file("res://scene/level_three.tscn")
